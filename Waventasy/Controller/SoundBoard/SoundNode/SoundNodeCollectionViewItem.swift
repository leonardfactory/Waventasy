//
//  SoundNodeCollectionViewItem.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 17/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

class SoundNodeCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var nameLabel:NSTextField?
    @IBOutlet weak var backgroundImageView:NSImageView?
    
    var node:SoundNode? {
        didSet {
            self.name = node?.name
            // La posizione viene gestita automaticamente dal layout
        }
    }
    
    // Titolo di questo nodo
    var name: String? {
        didSet {
            self.nameLabel?.stringValue = name ?? "<N.A.>"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
    }
    
}
