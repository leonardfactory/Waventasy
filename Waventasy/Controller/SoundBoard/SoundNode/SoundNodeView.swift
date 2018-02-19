//
//  SoundNodeView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 16/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

/**
 Protocollo per gestire le richieste del SoundNode
 */
protocol SoundNodeViewDelegate {
    // Permesso di avviare un link
    func canStartLink(fromNode node:SoundNode, atSlot slot:SoundNodeSlot) -> Bool
    // Permesso di terminare un link
    func canEndLink(toNode node:SoundNode, atSlot slot:SoundNodeSlot, link:SoundLink) -> Bool
    // Controlla se un link è in corso
    func findActiveLink() -> SoundLink?
    // Avvio del linking
    func startLink(fromNode node:SoundNode, atSlot slot:SoundNodeSlot) -> SoundLink
    // Terminazione del linking
    func endLink(toNode node:SoundNode, atSlot slot:SoundNodeSlot, link:SoundLink) -> Void
}

class SoundNodeView: BoardItemView {
    
//    public static var templateView:SoundNodeView = SoundNodeView(frame: NSRect(x:0.0, y:0.0, width: 100.0, height: 20.0))
//
//    public static func frameSizeForNode(_ node:SoundNode) -> NSRect {
//        templateView.node = node
//        return NSRect(origin: node.position, size: templateView.fittingSize)
//    }
//
    var nameLabel:NSTextField!
    var backgroundImageView:NSImageView!
    var trackingArea:NSTrackingArea!
    
    var inputSlotsView:NSStackView!
    var outputSlotsView:NSStackView!
    
    var inputSlotsViewItems:Dictionary<SoundNodeSlotInput, SoundNodeSlotInputView> = [:]
    var outputsSlotsViewItems:Dictionary<SoundNodeSlotOutput, SoundNodeSlotOutputView> = [:]
    
    var isDragging:Bool = false
    var draggingOrigin:CGPoint? = nil
    var draggingCurrent:CGPoint? = nil
    
    var nodeDelegate:SoundNodeViewDelegate? = nil
    
    var node:SoundNode? {
        didSet {
            self.name = node?.name
            
            if let node = node {
                self.frame = NSRect(origin: node.position, size:self.fittingSize)
            }
        }
    }
    
    // Titolo di questo nodo
    var name: String? {
        didSet {
            self.nameLabel?.stringValue = name ?? "<N.A.>"
        }
    }
    
    init(node: SoundNode) {
        super.init(frame: NSRect.zero)
        defer {
            self.node = node
            setup()
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
        // UI
        self.setupInterface()
        // Input slots
        self.setupSlots()
        self.setupSlotElements()
        
        if let node = node {
            // Update size
            self.frame = NSRect(origin: node.position, size:self.fittingSize)
        }
        
        // Tracking area
        trackingArea = NSTrackingArea(
            rect: self.bounds,
            options: [NSTrackingArea.Options.cursorUpdate, NSTrackingArea.Options.activeInKeyWindow, NSTrackingArea.Options.inVisibleRect],
            owner: self,
            userInfo: nil
        )
        self.addTrackingArea(trackingArea)
    }
    
    // Elementi dell'UI
    func setupInterface() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autoresizingMask = [.height, .width]
        
        backgroundImageView = NSImageView(image: NSImage(named: soundNodeBgImage(fromType: self.node?.type))!)
        backgroundImageView.imageScaling = .scaleAxesIndependently
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundImageView)
        
        nameLabel = NSTextField(labelWithString: "")
        nameLabel.font = NSFont.systemFont(ofSize: 12.0, weight: .bold)
        nameLabel.textColor = NSColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        
        // Constraints
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6.0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0).isActive = true
    }
    
    // Slot
    func setupSlots() {
        inputSlotsView = NSStackView(frame: NSRect.zero)
        inputSlotsView.orientation = .vertical
        inputSlotsView.alignment = .leading
        inputSlotsView.spacing = 0.0
        inputSlotsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(inputSlotsView)
        
        outputSlotsView = NSStackView(frame: NSRect.zero)
        outputSlotsView.orientation = .vertical
        outputSlotsView.alignment = .trailing
        outputSlotsView.spacing = 0.0
        outputSlotsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(outputSlotsView)
        
        inputSlotsView.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 4.0).isActive = true
        inputSlotsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
        inputSlotsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0).isActive = true
        
        outputSlotsView.topAnchor.constraint(equalTo: inputSlotsView.topAnchor).isActive = true
        outputSlotsView.bottomAnchor.constraint(equalTo: inputSlotsView.bottomAnchor).isActive = true
        outputSlotsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0).isActive = true
        
        inputSlotsView.trailingAnchor.constraint(equalTo: outputSlotsView.leadingAnchor, constant:-4.0).isActive = true
    }
    
    func setupSlotElements() {
        if self.node != nil {
            for slot in self.node!.inputs {
                let slotView = SoundNodeSlotInputView(slot: slot, frame: NSRect.zero)
                slotView.delegate = self
                inputSlotsViewItems[slot] = slotView
                inputSlotsView.addView(slotView, in: .bottom)
            }
            for slot in self.node!.outputs {
                let slotView = SoundNodeSlotOutputView(slot: slot, frame: NSRect.zero)
                slotView.delegate = self
                outputsSlotsViewItems[slot] = slotView
                outputSlotsView.addView(slotView, in: .bottom)
            }
        }
    }
    
    // Cursor
    // -
    
    override func cursorUpdate(with event: NSEvent) {
        if (!self.isDragging && delegate!.canDragItem) {
            NSCursor.arrow.set()
        }
    }
    
    // Dragging
    // -
    
    override func mouseDown(with event: NSEvent) {
        // Draggin support
        if (event.type == NSEvent.EventType.leftMouseDown && delegate!.canDragItem) {
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
            self.draggingCurrent = self.draggingCurrent! + CGPoint(x: event.deltaX, y: event.deltaY)
            let desired:CGPoint = self.delegate?.toGridPoint(point: self.draggingCurrent!) ?? self.draggingCurrent!
            self.node?.position = desired
            self.frame = NSRect(origin: desired, size: self.frame.size)
            self.delegate?.mouseDragged(forItem: self)
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if (self.isDragging && event.type == NSEvent.EventType.leftMouseUp) {
            self.isDragging = false
            NSCursor.pop()
        }
    }
}

/**
 Gestione degli eventi di link, per girarli al parent
 */
extension SoundNodeView : SoundNodeSlotDelegate {
    func canStartLink(fromSlot slot: SoundNodeSlot) -> Bool {
        return nodeDelegate!.canStartLink(fromNode: node!, atSlot: slot)
    }
    
    func canEndLink(toSlot slot: SoundNodeSlot, link: SoundLink) -> Bool {
        return nodeDelegate!.canEndLink(toNode: node!, atSlot: slot, link: link)
    }
    
    func findActiveLink() -> SoundLink? {
        return nodeDelegate?.findActiveLink()
    }
    
    func startLink(fromSlot slot: SoundNodeSlot) -> SoundLink {
        return nodeDelegate!.startLink(fromNode: node!, atSlot: slot)
    }
    
    func endLink(toSlot slot: SoundNodeSlot, link: SoundLink) {
        return nodeDelegate!.endLink(toNode: node!, atSlot: slot, link: link)
    }
}
