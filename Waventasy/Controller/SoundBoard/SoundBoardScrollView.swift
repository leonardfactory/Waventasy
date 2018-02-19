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
        print("scrollview")
        if (event.keyCode == SpaceBarKeyCode && !self.isDragMode) {
            print("dragmode!")
            self.isDragMode = true
            NSCursor.openHand.push()
            self.window?.disableCursorRects()
        }
    }
    
    public override func keyUp(with event: NSEvent) {
        print("scrollviewup")
        if (event.keyCode == SpaceBarKeyCode) {
            print("enddragmode!")
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
//            self.window?.disableCursorRects()
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if (self.isDragging && event.type == NSEvent.EventType.leftMouseDragged) {
//            print("I'm gonna scroll", event.deltaY, event.deltaY)
//            print("Origin", NSStringFromRect(self.contentView.documentVisibleRect))
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
//
    }
    
//    override func resetCursorRects() {
//        super.resetCursorRects()
//    }
}
