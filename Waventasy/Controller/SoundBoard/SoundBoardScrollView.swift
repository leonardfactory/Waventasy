//
//  SoundBoardScrollView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 15/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

class SoundBoardScrollView: NSScrollView {
    var isDragging: Bool = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addCursorRect(self.frame, cursor: NSCursor.openHand)
    }
    
    

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
//        self.contentView. = NSSize(width: self.frame.size.width * 2, height: self.frame.size.width * 2)
    }
    
    override func mouseDown(with event: NSEvent) {
        // Draggin support
        if (event.type == NSEvent.EventType.leftMouseDown) {
            self.isDragging = true
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if (self.isDragging && event.type == NSEvent.EventType.leftMouseDragged) {
            print("I'm gonna scroll", event.deltaY, event.deltaY)
            print("Origin", NSStringFromRect(self.contentView.documentVisibleRect))
            self.contentView.scroll(NSPoint(
                x: self.contentView.documentVisibleRect.origin.x - event.deltaX,
                y: self.contentView.documentVisibleRect.origin.y + event.deltaY
            ))
//            self.scroll() event
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if (self.isDragging && event.type == NSEvent.EventType.leftMouseUp) {
            self.isDragging = false
        }
    }
}
