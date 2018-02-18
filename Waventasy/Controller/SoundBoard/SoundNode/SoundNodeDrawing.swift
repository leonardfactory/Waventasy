//
//  SoundNodeDrawing.swift
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
func soundNodeSwatchImage(fromType type:SoundNode.NodeType) -> NSImage {
    let color = soundNodeColor(fromType: type)
    
    let size = NSSize(width:12, height:12)
    let image = NSImage(size: size)
    image.lockFocus()
    color?.drawSwatch(in: NSRect(origin: NSPoint.zero, size: size))
    image.unlockFocus()
    
    return image
}

func soundNodeColor(fromType type:SoundNode.NodeType) -> NSColor? {
    switch (type) {
    case .frequency: return NSColor(hex: 0x00a8ff)
    case .harmonic: return NSColor(hex: 0x4cd137)
    }
}
