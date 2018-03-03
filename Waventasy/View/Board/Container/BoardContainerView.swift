//
//  BoardContainerView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 03/03/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

/// Contenitore di BoardItemView.
/// Necessario per l'ordinamento.
class BoardContainerView: NSView {
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.autoresizingMask = [.width, .height]
    }
    
    override var isFlipped: Bool { return true }
}
