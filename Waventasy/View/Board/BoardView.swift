//
//  BoardView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

func printResponderChain(from responder: NSResponder?) {
    print("-- Debugging responder chain")
    var responder = responder
    while let r = responder {
        print(r)
        responder = r.nextResponder
    }
}

/// La BoardView rappresenta il "pannello" sul quale è possibile aggiungere Nodi
/// e collegamenti fra di essi per il rendering.
public class BoardView: NSView {
    // Delegati
    var delegate:BoardDelegate? = nil
    var dataSource:BoardDataSource? = nil
    
    // Tracking
    var trackingArea:NSTrackingArea? = nil
    
    // Elementi
    var items:[BoardItem] = []
    var visibleItems:Set<BoardItemIdentifier> = []
    var renderedItems:Set<BoardItemIdentifier> = []
    var renderedSubviews:Dictionary<BoardItemIdentifier, BoardItemView> = [:]
    
    /// Link attualmente in creazione
    var activeLink:Link? = nil
    /// Location temporanea dell'end del Link
    var activeLinkEnding:CGPoint? = nil
    
    /// Ordinamento
    var containerTypes:[BoardItemType] = [.node, .link]
    var containerViews:Dictionary<BoardItemType, NSView> = [:]
    
    // Inizializzazione
    // -
    
    public required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    // Setup interno
    // -
    
    private func setup() {
        trackingArea = NSTrackingArea(
            rect: self.bounds,
            options: [.activeInKeyWindow, .mouseMoved, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        self.addTrackingArea(trackingArea!)
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor(hex: 0x2f3640).cgColor
        
        // View container
        for itemType in containerTypes {
            containerViews[itemType] = BoardContainerView(frame: self.bounds)
            self.addSubview(containerViews[itemType]!)
        }
        
    }
    
    // Eventi
    // -
    
    // E' importante qui impostare l'acceptsFirstResponder, altrimenti
    // la NSScrollView superiore **non** riceverà il keyDown.
    public override var acceptsFirstResponder: Bool { return true }
    
    // Caricamento dei dati
    // -
    
    public func reloadData() {
        if let dataSource = self.dataSource {
            let items = dataSource.itemsIn(boardView: self)
            let neededItems = Set(items.map({ (item) in
                return item.itemId
            }))
            
            let addedItems      = neededItems.subtracting(self.renderedItems)
            let removedItems    = self.renderedItems.subtracting(neededItems)
            let updatedItems    = neededItems.intersection(self.renderedItems)
            
//            print("New items for reloading", addedItems, removedItems, updatedItems)
            
            self.items = items
            addedItems.forEach({ (identifier) in self.addItem(identifier: identifier) })
            removedItems.forEach({ (identifier) in self.removeItem(identifier: identifier) })
            updatedItems.forEach({ (identifier) in self.updateItem(identifier: identifier) })
            
            // Display
            self.resizeDocumentView()
        }
    }
    
    /// Aggiunge un Nodo
    private func addItem(identifier:BoardItemIdentifier) {
        let foundItem = self.items.first { (item) -> Bool in
            return item.itemId == identifier
        }
        
        guard let item = foundItem else { fatalError("BoardView.addItem: not found") }
        guard let itemView = self.dataSource?.boardView(self, item: item, fromExistingView: nil) else { return }
        itemView.delegate = self
        
        self.containerViews[item.itemType]?.addSubview(itemView)
        self.renderedItems.insert(identifier)
        self.renderedSubviews[identifier] = itemView
    }
    
    /// Rimuove un nodo
    private func removeItem(identifier:BoardItemIdentifier) {
        self.renderedItems.remove(identifier)
        guard let subviewItem = self.renderedSubviews.first(where: { return $0.key == identifier }) else { return }
        self.renderedSubviews.removeValue(forKey: subviewItem.key)
        subviewItem.value.removeFromSuperview()
    }
    
    /// Aggiorna un nodo
    private func updateItem(identifier:BoardItemIdentifier) {
        let foundItem = self.items.first { (item) -> Bool in
            return item.itemId == identifier
        }
        
        guard let item = foundItem else { return }
        guard let subviewItem = self.renderedSubviews.first(where: { return $0.key == identifier }) else { return }
        
        _ = self.dataSource?.boardView(self, item: item, fromExistingView: subviewItem.value)
    }
    
    // Linking
    // -
    
    public override func mouseMoved(with event: NSEvent) {
        self.activeLinkEnding = self.convert(event.locationInWindow, from:nil)
        self.delegate?.boardView(self, mouseMoved: event)
    }
    
    // Display
    // -
    
    public override var isFlipped: Bool { return true }
    
    /// Dimensione della griglia
    public var gridSize = NSSize(width: 10.0, height: 10.0)
    
    /// Ridimensiona la content size
    private func resizeDocumentView() {
        if let dataSource = self.dataSource {
            self.setFrameSize(dataSource.contentRectFor(boardView: self).size)
        }
    }
    
    // Query
    // -
    
    /// Ottiene la vista renderizzata per l'item specificato.
    /// Può ritornare nil se non è stata ancora renderizzata.
    public func view(forItem item:BoardItemIdentifier) -> BoardItemView? {
        return renderedSubviews[item]
    }
}

/// Delegato per la Gestione degli elementi
extension BoardView : BoardItemViewDelegate {
    // Griglia
    public func toGridPoint(point:CGPoint) -> CGPoint {
        return (point / gridSize).floor() * gridSize
    }
    
    // Dragging
    var canDragItem: Bool {
        return !self.delegate!.isScrollViewDragging
    }
    
    func mouseDragged(forItem itemView: BoardItemView) {
        self.delegate?.boardView(self, mouseDraggedForItem: itemView)
    }
}
