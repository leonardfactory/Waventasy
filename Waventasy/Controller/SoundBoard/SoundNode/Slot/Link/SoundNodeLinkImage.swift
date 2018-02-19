//
//  SoundNodeLinkImage.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

let SoundNodeLinkImageSize = NSSize(width: 8.0, height: 8.0)
let SoundNodeLinkImageBulletSize = NSSize(width: 4.0, height: 4.0)

struct SoundNodeLinkColors {
    static let bgColor = NSColor(hex: 0xffffff, alpha: 0.5)
    static let activeBgColor = NSColor(hex: 0xffffff, alpha: 0.75)
    static let bulletColor = NSColor(hex:0xfffff)
}

struct SoundNodeLinkImage {
    static let unlinked = createSoundNodeLinkImage(linked:false, active:false)
    static let unlinkedActive = createSoundNodeLinkImage(linked:false, active:true)
    static let linked = createSoundNodeLinkImage(linked:true, active:false)
    static let linkedActive = createSoundNodeLinkImage(linked:true, active:true)
}

private func createSoundNodeLinkImage(linked:Bool, active:Bool) -> NSImage {
    let image = NSImage(size: SoundNodeLinkImageSize)
    let bgColor = active ? SoundNodeLinkColors.activeBgColor : SoundNodeLinkColors.bgColor
    
    image.lockFocus()
    let rect = NSRect(origin: NSPoint.zero, size:SoundNodeLinkImageSize)
    let path = NSBezierPath(roundedRect: rect, xRadius: 2.0, yRadius: 2.0)
    bgColor.setFill()
    path.fill()
    
    if (linked) {
        let center = NSPoint(x: rect.midX, y: rect.midY)
        let bulletRect = NSRect(
            origin: center - SoundNodeLinkImageBulletSize / 2.0,
            size: SoundNodeLinkImageBulletSize
        )
        let bulletPath = NSBezierPath(ovalIn: bulletRect)
        SoundNodeLinkColors.bulletColor.setFill()
        bulletPath.fill()
    }
    
    image.unlockFocus()
    return image
}
