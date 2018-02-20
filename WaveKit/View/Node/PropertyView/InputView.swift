//
//  InputView.swift
//  WaveKit
//
//  Created by Leonardo Ascione on 21/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

open class InputView : NSView {
    var delegate:PropertyViewDelegate? = nil
    
    var input:Input? {
        /// Aggiorno il rendering al Set.
        didSet {
            if let input = input {
                self.nameLabel?.stringValue = input.name
            }
        }
    }
    
    var nameLabel:NSTextField!
    var linkButton:NSButton!
    var numericInputField:NSTextField?
    
    public init(input:Input, frame frameRect:NSRect) {
        super.init(frame: frameRect)
        
        defer {
            self.input = input
            setup()
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    public required init?(coder decoder: NSCoder) {
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
        
        self.nameLabel = NSTextField(labelWithString: self.input?.name ?? "")
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
        if let input = self.input {
            // Creo l'input in base al tipo
            switch (input.value) {
            case .double, .int:
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
                numericInputField?.stringValue = input.value.stringValue
                addSubview(numericInputField!)
                
                numericInputField?.widthAnchor.constraint(greaterThanOrEqualToConstant: 26.0).isActive = true
                numericInputField?.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor).isActive = true
                numericInputField?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
                nameLabel.trailingAnchor.constraint(equalTo: numericInputField!.leadingAnchor, constant: -4).isActive = true
                
            default:
                nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
        }
    }
    
    // Un input link può ricevere i link solo in ingresso
    @objc func linkPressed() {
        guard let delegate = self.delegate else { return }
        
        if let activeLink = delegate.findActiveLink() {
            if delegate.canEndLink(to: input!, link: activeLink) {
                delegate.endLink(to: input!, link: activeLink)
            }
            else {
                print("Impossibile collegare a questo nodo")
            }
        }
    }
}

extension InputView : NSTextFieldDelegate {
    open override func controlTextDidEndEditing(_ obj: Notification) {
        guard let input = input else { return }
        switch (input.value) {
            case .double:
                input.value = .double(numericInputField?.doubleValue ?? 0.0)
            
            case .int:
                input.value = .int(numericInputField?.integerValue ?? 0)
            
            default: break
        }
    }
}
