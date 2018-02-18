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
    
    private var _node:SoundNode? = nil
    
    var isDragging:Bool = false
    var draggingOrigin:CGPoint? = nil
    var draggingCurrent:CGPoint? = nil
    
    var node:SoundNode? {
        didSet {
            self._node = node
            self.name = node?.name
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
        var topLevelObjects : NSArray?
        if Bundle.main.loadNibNamed(NSNib.Name(rawValue: "SoundNodeView"), owner: self, topLevelObjects: &topLevelObjects) {
            self.view = topLevelObjects!.first(where: { $0 is NSView }) as? NSView
            self.view.wantsLayer = true
            
            self.addSubview(self.view)
            self.view.translatesAutoresizingMaskIntoConstraints = true
            self.view.autoresizingMask = [.width, .height]
            self.view.frame = self.bounds
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
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
