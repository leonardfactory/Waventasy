//
//  SoundNodeSlotView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

class SoundNodeSlotView: NSView {
    var _slot:SoundNodeSlot? = nil

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
        
//        self.nameLabel.stringValue = slot.name
//        self.setFrameSize(self.fittingSize)
//
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
//        self.view = self.loadFromNib(nibName: "SoundNodeSlotView")
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer?.backgroundColor = CGColor.clear
        
        self.nameLabel = NSTextField(labelWithString: "")
        self.nameLabel.drawsBackground = false
        self.nameLabel.font = NSFont.systemFont(ofSize: 11.0)
        self.nameLabel.textColor = NSColor(hex: 0xffffff)
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        
        self.linkButton = NSButton(image: SoundNodeLinkImage.unlinked, target:self, action: #selector(linkPressed))
        self.linkButton.imagePosition = .imageOnly
        self.linkButton.isBordered = false
        self.linkButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(linkButton)
        
        // Constraints
        self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        
        self.linkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.linkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true
        self.linkButton.widthAnchor.constraint(equalToConstant: SoundNodeLinkImageSize.width).isActive = true
        self.linkButton.heightAnchor.constraint(equalToConstant: SoundNodeLinkImageSize.height).isActive = true
        
        self.nameLabel.trailingAnchor.constraint(equalTo: self.linkButton.leadingAnchor, constant: -8).isActive = true
    }
    
    @objc func linkPressed() {
        
    }
}
