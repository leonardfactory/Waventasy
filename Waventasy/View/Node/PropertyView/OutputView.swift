//
//  OutputView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 21/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

/// Visualizzazione di una proprietà di Output di un Nodo.
class OutputView : NSView {
    var delegate:PropertyViewDelegate? = nil
    
    var output:Output? {
        didSet {
            if let output = output {
                self.nameLabel.stringValue = output.name
            }
        }
    }
    
    var nameLabel:NSTextField!
    var linkButton:NSButton!
    
    init(output:Output, frame frameRect:NSRect) {
        super.init(frame: frameRect)
        setup()
        
        defer {
            self.output = output
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
        
        self.linkButton = NSButton(image: PropertyLinkImage.unlinked, target:self, action: #selector(linkPressed))
        self.linkButton.imagePosition = .imageOnly
        self.linkButton.isBordered = false
        self.linkButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(linkButton)
        
        // Constraints
        self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        self.linkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.linkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.linkButton.widthAnchor.constraint(equalToConstant: PropertyLinkImageSize.width).isActive = true
        self.linkButton.heightAnchor.constraint(equalToConstant: PropertyLinkImageSize.height).isActive = true
        
        self.nameLabel.trailingAnchor.constraint(equalTo: self.linkButton.leadingAnchor, constant: -4.0).isActive = true
    }
    
    // Un output link può attivare i link ma non riceverne
    @objc func linkPressed() {
        guard let delegate = self.delegate else { return }
        
        if (delegate.findActiveLink()) != nil {
            print("Link già in corso")
            return
        }
        
        if delegate.canStartLink(from: output!) {
            _ = delegate.startLink(from: output!)
        }
        else {
            print("Impossibile partire da questo nodo")
        }
    }
}


