//
//  NodeView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 21/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

/// Protocollo per gestire le richieste del SoundNode
protocol NodeViewDelegate {
    // Permesso di avviare un link
    func canStartLink(fromNode node:Node, at output:Output) -> Bool
    // Permesso di terminare un link
    func canEndLink(toNode node:Node, at input:Input, link:Link) -> Bool
    // Controlla se un link è in corso
    func findActiveLink() -> Link?
    // Avvio del linking
    func startLink(fromNode node:Node, at output:Output) -> Link
    // Terminazione del linking
    func endLink(toNode node:Node, at input:Input, link:Link) -> Void
}

/// Visualizzazione di un singolo Nodo
class NodeView : BoardItemView {
    var nameLabel:NSTextField!
    var backgroundImageView:NSImageView!
    var trackingArea:NSTrackingArea!
    
    var inputsView:NSStackView!
    var outputsView:NSStackView!
    
    /// View di Input
    var inputSubviews:Dictionary<Input, InputView> = [:]
    /// View di Output
    var outputSubviews:Dictionary<Output, OutputView> = [:]
    
    /// Specifica se il nodo è attualmente in movimento
    var isDragging:Bool = false
    /// Origine del movimento di trascinamento
    var draggingOrigin:CGPoint? = nil
    /// Posizione corrente del movimento di trascinamento
    var draggingCurrent:CGPoint? = nil
    
    var nodeDelegate:NodeViewDelegate? = nil
    
    var node:Node? {
        didSet {
            self.name = node?.name
            
            if let node = node {
                self.frame = NSRect(origin: node.position, size:self.fittingSize)
                self.needsDisplay = true
            }
        }
    }
    
    // Titolo di questo nodo
    var name: String? {
        didSet {
            self.nameLabel?.stringValue = name ?? "<N.A.>"
        }
    }
    
    init(node: Node) {
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
        self.setupProps()
        self.setupPropElements()
        
        if let node = node {
            // Update size
            self.frame = NSRect(origin: node.position, size:self.fittingSize)
        }
        
        // Tracking area
        trackingArea = NSTrackingArea(
            rect: self.bounds,
            options: [.cursorUpdate, .activeInKeyWindow, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        self.addTrackingArea(trackingArea)
    }
    
    /// Crea gli elementi dell'UI di base
    func setupInterface() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.autoresizingMask = [.none]
        
        backgroundImageView = NSImageView(image: NSImage(named: nodeBgImage(fromType: self.node?.type))!)
        backgroundImageView.imageScaling = .scaleAxesIndependently
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundImageView)
        
        nameLabel = NSTextField(labelWithString: "")
        nameLabel.font = NSFont.systemFont(ofSize: 12.0, weight: .bold)
        nameLabel.textColor = NSColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        
        // Focus ring
        self.focusRingType = .exterior
        
        // Constraints
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6.0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0).isActive = true
    }
    
    /// Prepara la visualizzazione delle Proprietà, sia in Input che in Output
    func setupProps() {
        inputsView = NSStackView(frame: NSRect.zero)
        inputsView.orientation = .vertical
        inputsView.alignment = .leading
        inputsView.spacing = 0.0
        inputsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(inputsView)
        
        outputsView = NSStackView(frame: NSRect.zero)
        outputsView.orientation = .vertical
        outputsView.alignment = .trailing
        outputsView.spacing = 0.0
        outputsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(outputsView)
        
        inputsView.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 4.0).isActive = true
        inputsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
        inputsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0).isActive = true
        
        outputsView.topAnchor.constraint(equalTo: inputsView.topAnchor).isActive = true
        outputsView.bottomAnchor.constraint(equalTo: inputsView.bottomAnchor).isActive = true
        outputsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0).isActive = true
        
        inputsView.trailingAnchor.constraint(equalTo: outputsView.leadingAnchor, constant:-4.0).isActive = true
    }
    
    func setupPropElements() {
        if self.node != nil {
            for input in self.node!.inputs {
                let inputView = InputView(input: input, frame: NSRect.zero)
                inputView.delegate = self
                inputSubviews[input] = inputView
                inputsView.addView(inputView, in: .bottom)
            }
            for output in self.node!.outputs {
                let outputView = OutputView(output: output, frame: NSRect.zero)
                outputView.delegate = self
                outputSubviews[output] = outputView
                outputsView.addView(outputView, in: .bottom)
            }
        }
    }
    
    // Selection
    // -
    
    override var acceptsFirstResponder: Bool { return true }
    
    override func keyDown(with event: NSEvent) {
        // print("key down for nodeview", node?.name ?? "<N.A.>")
    }
    
    override var focusRingMaskBounds: NSRect { return self.bounds }
    
    /// Crea la _shape_ sulla quale verrà mostrato il Focus Ring.
    /// Il colore non è rilevante in quanto serve solamente la path
    override func drawFocusRingMask() {
        let rounded = NSBezierPath(roundedRect: self.bounds.insetBy(dx: 1.0, dy: 1.0), xRadius: 5.0, yRadius: 5.0)
        NSColor.white.set()
        rounded.fill()
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
        self.window?.makeFirstResponder(self)
        super.mouseDown(with: event)
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
        super.mouseUp(with: event)
        if (self.isDragging && event.type == NSEvent.EventType.leftMouseUp) {
            self.isDragging = false
            NSCursor.pop()
        }
    }
}

/// Gestione degli eventi di link, per girarli al parent
extension NodeView : PropertyViewDelegate {
    func canStartLink(from output: Output) -> Bool {
        return nodeDelegate!.canStartLink(fromNode: node!, at: output)
    }
    
    func canEndLink(to input: Input, link: Link) -> Bool {
        return nodeDelegate!.canEndLink(toNode: node!, at: input, link: link)
    }
    
    func findActiveLink() -> Link? {
        return nodeDelegate?.findActiveLink()
    }
    
    func startLink(from output: Output) -> Link {
        return nodeDelegate!.startLink(fromNode: node!, at: output)
    }
    
    func endLink(to input: Input, link: Link) {
        return nodeDelegate!.endLink(toNode: node!, at: input, link: link)
    }
}

