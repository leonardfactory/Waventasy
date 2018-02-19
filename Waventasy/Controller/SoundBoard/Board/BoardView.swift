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


public class BoardView: NSView {
    // Delegati
    var delegate:BoardDelegate? = nil
    var dataSource:BoardDataSource? = nil
    
    // Tracking
    var trackingArea:NSTrackingArea? = nil
    
    // Elementi
    var items:[BoardRenderable] = []
    var visibleItems:Set<BoardItemIdentifier> = []
    var renderedItems:Set<BoardItemIdentifier> = []
    var renderedSubviews:Dictionary<BoardItemIdentifier, BoardItemView> = [:]
    
    var gridSize:CGFloat { return 10.0 }
    
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
            let items = dataSource.boardView(itemsIn: self)
            let neededItems = Set(items.map({ (item) in
                return item.boardIdentifier
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
    
    // Aggiunge un Nodo
    private func addItem(identifier:BoardItemIdentifier) {
        let foundItem = self.items.first { (item) -> Bool in
            return item.boardIdentifier == identifier
        }
        
        guard let item = foundItem else { fatalError("BoardView.addItem: not found") }
        guard let itemView = self.dataSource?.boardView(self, item: item, fromExistingView: nil) else { return }
        itemView.delegate = self
        
        self.addSubview(itemView)
        self.renderedItems.insert(identifier)
        self.renderedSubviews[identifier] = itemView
    }
    
    // Rimuove un nodo
    private func removeItem(identifier:BoardItemIdentifier) {
        self.renderedItems.remove(identifier)
        guard let subviewItem = self.renderedSubviews.first(where: { return $0.key == identifier }) else { return }
        self.renderedSubviews.removeValue(forKey: subviewItem.key)
        subviewItem.value.removeFromSuperview()
    }
    
    // Aggiorna un nodo
    private func updateItem(identifier:BoardItemIdentifier) {
        let foundItem = self.items.first { (item) -> Bool in
            return item.boardIdentifier == identifier
        }
        
        guard let item = foundItem else { return }
        guard let subviewItem = self.renderedSubviews.first(where: { return $0.key == identifier }) else { return }
        
        _ = self.dataSource?.boardView(self, item: item, fromExistingView: subviewItem.value)
    }
    
    // Linking
    // -
    
    public override func mouseMoved(with event: NSEvent) {
        self.delegate?.boardView(self, mouseMoved: event)
    }
    
    // Display
    // -
    
    public override var isFlipped: Bool { return true }
    
    // Ridimensiona la content size
    private func resizeDocumentView() {
        if let dataSource = self.dataSource {
//            print("refreshed document size", dataSource.boardView(contentRectFor: self))
//            self.frame = dataSource.boardView(contentSizeFor: self)
            self.setFrameSize(dataSource.boardView(contentRectFor: self).size)
        }
    }
    
    // Query
    // -
    public func view(forItem item:BoardItemIdentifier) -> BoardItemView? {
        return renderedSubviews[item]
    }
}

/**
 Gestione degli elementi
 */
extension BoardView : BoardItemViewDelegate {
    // Griglia
    public func toGridPoint(point:CGPoint) -> CGPoint {
        return CGPoint(
            x: floor(point.x / GridSize) * GridSize,
            y: floor(point.y / GridSize) * GridSize
        )
    }
    
    // Dragging
    var canDragItem: Bool {
        return !self.delegate!.isScrollViewDragging
    }
    
    func mouseDragged(forItem itemView: BoardItemView) {
        self.delegate?.boardView(self, mouseDraggedForItem: itemView)
    }
}
