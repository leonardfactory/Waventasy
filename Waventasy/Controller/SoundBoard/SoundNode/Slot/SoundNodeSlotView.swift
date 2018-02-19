//
//  SoundNodeSlotView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

class SoundNodeSlotView: NSView {
    var slot:SoundNodeSlot? {
        didSet {
            if let slot = slot {
                self.nameLabel.stringValue = slot.name
                self.setFrameSize(self.fittingSize)
            }
        }
    }
    
    var nameLabel:NSTextField!
    var linkButton:NSButton!

    init(slot:SoundNodeSlot, frame frameRect:NSRect) {
        super.init(frame: frameRect)
        setup()
    
        defer {
            self.slot = slot
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
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer?.backgroundColor = CGColor.clear
        
        self.nameLabel = NSTextField(labelWithString: "")
        self.nameLabel.drawsBackground = false
        self.nameLabel.font = NSFont.systemFont(ofSize: 10.0)
        self.nameLabel.textColor = NSColor(hex: 0xffffff)
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        
        self.linkButton = NSButton(image: SoundNodeLinkImage.unlinked, target:self, action: #selector(linkPressed))
        self.linkButton.imagePosition = .imageOnly
        self.linkButton.isBordered = false
        self.linkButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(linkButton)
    }

    @objc func linkPressed() {
        
    }
}
