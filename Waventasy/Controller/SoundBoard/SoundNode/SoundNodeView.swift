//
//  SoundNodeView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 16/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

class SoundNodeView: NSView {
    
    @IBOutlet weak var topView:NSView!
    @IBOutlet weak var nameLabel:NSTextField?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }
    
    func setup() {
//        wantsLayer = true
        var tops: NSArray? = nil
        Bundle.main.loadNibNamed(NSNib.Name(rawValue: "SoundNodeView"), owner: self, topLevelObjects: &tops)
        self.topView.frame = self.bounds
        self.addSubview(self.topView)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    
}
