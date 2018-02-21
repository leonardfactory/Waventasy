//
//  LinkView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 19/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa


/// Protocollo che fornisce le informazioni di posizione per un Link.
protocol LinkViewDelegate {
    func color(forLink link:Link?) -> NSColor
    func startingPoint(forLink link:Link?) -> CGPoint
    func endingPoint(forLink link:Link?) -> CGPoint
}

/// Visualizzazione di un singolo Link fra due nodi
class LinkView: BoardItemView {
    var link:Link? {
        didSet {
            if link != nil {
                self.frame = linkRect()
                self.needsDisplay = true
            }
        }
    }
    
    var linkDelegate:LinkViewDelegate? = nil
    
    override var isFlipped: Bool { return true }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    init(link:Link) {
        super.init(frame: NSRect.zero)
        
        defer {
            self.link = link
            setup()
        }
    }
    
    func setup() {
        self.frame = linkRect()
    }
    
    func linkRect() -> NSRect {
        guard let delegate = linkDelegate else { return NSRect.zero }
        
        let starting = delegate.startingPoint(forLink: link)
        let ending   = delegate.endingPoint(forLink: link)
        return NSRect(
            x: min(starting.x, ending.x), y: min(starting.y, ending.y),
            width: abs(ending.x - starting.x), height: abs(ending.y - starting.y)
        ).insetBy(dx: -6, dy: -6)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let delegate = linkDelegate else { fatalError("Delegate is required for link view") }
        
        let starting = self.superview!.convert(delegate.startingPoint(forLink: link), to: self)
        let ending   = self.superview!.convert(delegate.endingPoint(forLink: link), to:self)
        
        let line = NSBezierPath()
        line.move(to: starting)
        line.line(to: ending)
        line.lineCapStyle = .roundLineCapStyle
        line.lineWidth = 2.0
        delegate.color(forLink: link).set()
        line.stroke()
    }
}
