//
//  SoundNodeSlotInputView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

/**
 Input
 */
class SoundNodeSlotInputView : NSView {
    var delegate:SoundNodeSlotDelegate? = nil
    
    var slot:SoundNodeSlotInput? {
        didSet {
            if let slot = slot {
                self.nameLabel?.stringValue = slot.name
            }
        }
    }
    
    var nameLabel:NSTextField!
    var linkButton:NSButton!
    var numericInputField:NSTextField?
    
    init(slot:SoundNodeSlotInput, frame frameRect:NSRect) {
        super.init(frame: frameRect)
        
        defer {
            self.slot = slot
            setup()
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
        self.setupElements()
        self.setupInput()
    }
    
    func setupElements() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer?.backgroundColor = CGColor.clear
        
        self.nameLabel = NSTextField(labelWithString: self.slot?.name ?? "")
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
        
        // Constraints
        self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        
        self.linkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.linkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.linkButton.widthAnchor.constraint(equalToConstant: SoundNodeLinkImageSize.width).isActive = true
        self.linkButton.heightAnchor.constraint(equalToConstant: SoundNodeLinkImageSize.height).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: linkButton.trailingAnchor, constant: 4).isActive = true
    }
    
    func setupInput() {
        if let slot = self.slot {
            // Creo l'input in base al tipo
            switch (slot.type) {
            case .decimal, .int:
                numericInputField = NSTextField(string: "10")
                numericInputField?.wantsLayer = true
                numericInputField?.font = NSFont.systemFont(ofSize: 10.0)
                numericInputField?.textColor = NSColor.white
                numericInputField?.backgroundColor = NSColor(hex: 0xffffff, alpha:0.5)
                numericInputField?.isBordered = false
                numericInputField?.bezelStyle = .roundedBezel
                numericInputField?.formatter = NumberFormatter()
                numericInputField?.translatesAutoresizingMaskIntoConstraints = false
                numericInputField?.layer = CALayer()
                numericInputField?.layer?.backgroundColor = NSColor(hex: 0xffffff, alpha:0.5).cgColor
                numericInputField?.layer?.cornerRadius = 3.0
                numericInputField?.layer?.borderWidth = 0
                numericInputField?.drawsBackground = false
                numericInputField?.delegate = self
                addSubview(numericInputField!)
                
                numericInputField?.widthAnchor.constraint(greaterThanOrEqualToConstant: 26.0).isActive = true
                numericInputField?.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor).isActive = true
                numericInputField?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
                nameLabel.trailingAnchor.constraint(equalTo: numericInputField!.leadingAnchor, constant: -4).isActive = true
                break;
                
            default:
                nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
        }
    }
    
    // Un input link può ricevere i link solo in ingresso
    @objc func linkPressed() {
        guard let delegate = self.delegate else { return }
        
        if let activeLink = delegate.findActiveLink() {
            if delegate.canEndLink(toSlot: slot!, link: activeLink) {
                delegate.endLink(toSlot: slot!, link: activeLink)
            }
            else {
                print("Impossibile collegare a questo nodo")
            }
        }
    }
}

extension SoundNodeSlotInputView : NSTextFieldDelegate {
    override func controlTextDidEndEditing(_ obj: Notification) {
        guard let slotType = self.slot?.type else { return }
        switch (slotType) {
        case .decimal:
            self.slot?.floatValue = numericInputField?.floatValue
            break
        case .int:
            self.slot?.intValue = numericInputField?.integerValue
            
        default: break
        }
    }
}
