//
//  SoundNodeCollectionViewItem.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 17/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

let GridSize:CGFloat = 10.0

class SoundNodeCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var nameLabel:NSTextField?
    @IBOutlet weak var backgroundImageView:NSImageView?
    
    var isDragging:Bool = false
    var draggingOrigin:CGPoint? = nil
    var draggingCurrent:CGPoint? = nil
    
    var node:SoundNode? {
        didSet {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
    }
    
    override func mouseDown(with event: NSEvent) {
        // Draggin support
        if (event.type == NSEvent.EventType.leftMouseDown) {
            self.isDragging = true
            self.draggingOrigin = self.view.frame.origin
            self.draggingCurrent = self.draggingOrigin
            NSCursor.closedHand.push()
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if (self.isDragging && event.type == NSEvent.EventType.leftMouseDragged) {
            //            print("I'm gonna scroll", event.deltaY, event.deltaY)
            //            print("Origin", NSStringFromRect(self.contentView.documentVisibleRect))
            self.draggingCurrent = self.draggingCurrent! + CGPoint(x: event.deltaX, y: event.deltaY)
            let desired = CGPoint(
                x: floor(self.draggingCurrent!.x / GridSize) * GridSize,
                y: floor(self.draggingCurrent!.y / GridSize) * GridSize
            )
            self.view.frame = NSRect(origin: desired, size: self.view.frame.size)
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
