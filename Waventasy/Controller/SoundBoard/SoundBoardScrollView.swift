//
//  SoundBoardScrollView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 15/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

let SpaceBarKeyCode = 49

class SoundBoardScrollView: NSScrollView {
    var isDragMode: Bool = false // Spacebar
    var isDragging: Bool = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {}

    public override var acceptsFirstResponder: Bool { return true }
    
    public override func keyDown(with event: NSEvent) {
        if (event.keyCode == SpaceBarKeyCode && !self.isDragMode) {
            self.isDragMode = true
            NSCursor.openHand.push()
            self.window?.disableCursorRects()
        }
    }
    
    public override func keyUp(with event: NSEvent) {
        if (event.keyCode == SpaceBarKeyCode) {
            self.isDragMode = false
            NSCursor.pop()
            self.stopDragging()
            self.window?.enableCursorRects()
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        // Draggin support
        if (self.isDragMode && event.type == NSEvent.EventType.leftMouseDown) {
            self.isDragging = true
            NSCursor.closedHand.push()
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if (self.isDragging && event.type == NSEvent.EventType.leftMouseDragged) {
            self.contentView.scroll(NSPoint(
                x: self.contentView.documentVisibleRect.origin.x - event.deltaX,
                y: self.contentView.documentVisibleRect.origin.y - event.deltaY
            ))
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if (self.isDragging && event.type == NSEvent.EventType.leftMouseUp) {
            self.stopDragging()
        }
    }
    
    func stopDragging() {
        self.isDragging = false
        NSCursor.pop()
    }
}
