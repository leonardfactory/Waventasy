//
//  NodeDrawing.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import Cocoa

/**
 Crea un'immagine campione dal colore di un tipo di SoundNode
 */
func nodeSwatchImage(fromType type:NodeType) -> NSImage {
    let color = nodeColor(fromType: type)
    
    let size = NSSize(width:12, height:12)
    let image = NSImage(size: size)
    let rect = NSRect(origin: NSPoint.zero, size: size)
    image.lockFocus()
    let roundedPath = NSBezierPath(roundedRect: rect, xRadius: 2.0, yRadius: 2.0)
    color.setFill()
    roundedPath.fill()
    image.unlockFocus()
    
    return image
}

func nodeColor(fromType type:NodeType) -> NSColor {
    switch (type) {
        case .frequency: return NSColor(hex: 0x00a8ff)
        case .harmonic: return NSColor(hex: 0x4cd137)
        case .constant: return NSColor(hex: 0x353b48)
    }
}

func nodeBgImage(fromType type:NodeType?) -> NSImage.Name {
    guard let type = type else {
        return NSImage.Name.blueNodeBg
    }
    
    switch (type) {
        case .frequency: return NSImage.Name.blueNodeBg
        case .harmonic: return NSImage.Name.greenNodeBg
        case .constant: return NSImage.Name.grayNodeBg
    }
}
