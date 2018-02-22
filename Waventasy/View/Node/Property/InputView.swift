//
//  InputView.swift
//  Waventasy
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
    var valueField:ValueField?
    
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
        
        self.linkButton = NSButton(image: PropertyLinkImage.unlinked, target:self, action: #selector(linkPressed))
        self.linkButton.imagePosition = .imageOnly
        self.linkButton.isBordered = false
        self.linkButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(linkButton)
        
        // Constraints
        self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        
        self.linkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.linkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.linkButton.widthAnchor.constraint(equalToConstant: PropertyLinkImageSize.width).isActive = true
        self.linkButton.heightAnchor.constraint(equalToConstant: PropertyLinkImageSize.height).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: linkButton.trailingAnchor, constant: 4).isActive = true
    }
    
    func setupInput() {
        if let input = self.input {
            valueField = ValueField.create(forProperty: input)
            addSubview(valueField!)
            
            nameLabel.trailingAnchor.constraint(equalTo: valueField!.leadingAnchor, constant: -4).isActive = true
            valueField!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
            
            if valueField!.requiredConstraints.contains(.baseline) {
                print("baselineanchor")
                valueField!.firstBaselineAnchor.constraint(equalTo: nameLabel.firstBaselineAnchor).isActive = true
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
