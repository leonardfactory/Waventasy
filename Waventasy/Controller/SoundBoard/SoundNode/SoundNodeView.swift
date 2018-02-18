//
//  SoundNodeView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 16/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

class SoundNodeView: BoardItemView {
    
    public static var templateView:SoundNodeView = SoundNodeView(frame: NSRect(x:0.0, y:0.0, width: 100.0, height: 20.0))
    
    public static func frameSizeForNode(_ node:SoundNode) -> NSRect {
        templateView.node = node
        return NSRect(origin: node.position, size: templateView.fittingSize)
    }
    
    @IBOutlet weak var view:NSView!
    @IBOutlet weak var nameLabel:NSTextField?
    
    var inputSlotsView:NSStackView!
    var outputSlotsView:NSStackView!
    
    private var _node:SoundNode? = nil
    
    var isDragging:Bool = false
    var draggingOrigin:CGPoint? = nil
    var draggingCurrent:CGPoint? = nil
    
    var node:SoundNode? {
        didSet {
            self._node = node
            self.name = node?.name
            self.addSlots()
            // La posizione viene gestita automaticamente dal layout
        }
    }
    
    // Titolo di questo nodo
    var name: String? {
        didSet {
            self.nameLabel?.stringValue = name ?? "<N.A.>"
        }
    }
    
    init(node: SoundNode) {
        super.init(frame: SoundNodeView.frameSizeForNode(node))
        setup()
        
        defer {
            self.node = node
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }
    
    func setup() {
        self.view = self.loadFromNib(nibName: "SoundNodeView")
        
        self.setupSlots()
    }
    
    func setupSlots() {
        inputSlotsView = NSStackView(frame: NSRect.zero)
        inputSlotsView.orientation = .vertical
        inputSlotsView.alignment = .leading
        inputSlotsView.spacing = 0.0
        inputSlotsView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(inputSlotsView)
        inputSlotsView.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 8.0).isActive = true
        inputSlotsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
        inputSlotsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
        inputSlotsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
    }
    
    func addSlots() {
        for slotItem in self.node!.inputs {
            let slot = slotItem.value
            
            let slotView = SoundNodeSlotView(slot: slot, frame: NSRect.zero)
            inputSlotsView.addView(slotView, in: .bottom)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        // Draggin support
        if (event.type == NSEvent.EventType.leftMouseDown) {
            self.isDragging = true
            self.draggingOrigin = self.frame.origin
            self.draggingCurrent = self.draggingOrigin
            NSCursor.closedHand.push()
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if (self.isDragging && event.type == NSEvent.EventType.leftMouseDragged) {
            //            print("I'm gonna scroll", event.deltaY, event.deltaY)
            //            print("Origin", NSStringFromRect(self.contentView.documentVisibleRect))
            self.draggingCurrent = self.draggingCurrent! + CGPoint(x: event.deltaX, y: -event.deltaY)
            let desired = CGPoint(
                x: floor(self.draggingCurrent!.x / GridSize) * GridSize,
                y: floor(self.draggingCurrent!.y / GridSize) * GridSize
            )
            self.frame = NSRect(origin: desired, size: self.frame.size)
            //            self.contentView.scroll(NSPoint(
            //                x: self.contentView.documentVisibleRect.origin.x - event.deltaX,
            //                y: self.contentView.documentVisibleRect.origin.y + event.deltaY
            //            ))
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if (self.isDragging && event.type == NSEvent.EventType.leftMouseUp) {
            self.isDragging = false
            NSCursor.pop()
            //            self.window?.enableCursorRects()
        }
    }
}
