//
//  SoundNodeLinkImage.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

let PropertyLinkImageSize = NSSize(width: 8.0, height: 8.0)
let PropertyLinkImageBulletSize = NSSize(width: 4.0, height: 4.0)

struct LinkColors {
    static let bgColor = NSColor(hex: 0xffffff, alpha: 0.5)
    static let activeBgColor = NSColor(hex: 0xffffff, alpha: 0.75)
    static let bulletColor = NSColor(hex:0xfffff)
    
    static let activeLineColor = NSColor(hex: 0xfbc531, alpha: 0.7)
    static let completeLineColor = NSColor(hex: 0xffffff, alpha: 0.7)
}

struct PropertyLinkImage {
    static let unlinked = createPropertyLinkImage(linked:false, active:false)
    static let unlinkedActive = createPropertyLinkImage(linked:false, active:true)
    static let linked = createPropertyLinkImage(linked:true, active:false)
    static let linkedActive = createPropertyLinkImage(linked:true, active:true)
}

private func createPropertyLinkImage(linked:Bool, active:Bool) -> NSImage {
    let image = NSImage(size: PropertyLinkImageSize)
    let bgColor = active ? LinkColors.activeBgColor : LinkColors.bgColor
    
    image.lockFocus()
    let rect = NSRect(origin: NSPoint.zero, size:PropertyLinkImageSize)
    let path = NSBezierPath(roundedRect: rect, xRadius: 2.0, yRadius: 2.0)
    bgColor.setFill()
    path.fill()
    
    if (linked) {
        let center = NSPoint(x: rect.midX, y: rect.midY)
        let bulletRect = NSRect(
            origin: center - PropertyLinkImageBulletSize / 2.0,
            size: PropertyLinkImageBulletSize
        )
        let bulletPath = NSBezierPath(ovalIn: bulletRect)
        LinkColors.bulletColor.setFill()
        bulletPath.fill()
    }
    
    image.unlockFocus()
    return image
}
