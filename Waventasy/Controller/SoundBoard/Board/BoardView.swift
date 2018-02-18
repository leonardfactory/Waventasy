//
//  BoardView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

public class BoardView: NSView {
    // Delegati
    var delegate:BoardDelegate? = nil
    var dataSource:BoardDataSource? = nil
    
    // Elementi
    var items:[BoardRenderable] = []
    var visibleItems:Set<BoardItemIdentifier> = []
    var renderedItems:Set<BoardItemIdentifier> = []
    var renderedSubviews:Dictionary<BoardItemIdentifier, BoardItemView> = [:]
    
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
        
    }
    
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
    
    // Display
    // -
    
    // Ridimensiona la content size
    private func resizeDocumentView() {
        if let dataSource = self.dataSource {
            self.frame = NSRect(
                origin:self.frame.origin,
                size: dataSource.boardView(contentSizeFor: self)
            )
        }
    }
}
