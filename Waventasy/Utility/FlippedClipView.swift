//
//  FlippedClipView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 17/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

class FlippedClipView: NSClipView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override var isFlipped: Bool { return true }
}
