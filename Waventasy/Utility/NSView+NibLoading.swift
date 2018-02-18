//
//  NSView+NibLoading.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

extension NSView {
    func loadFromNib(nibName:String) -> NSView? {
        var topLevelObjects : NSArray?
        if Bundle.main.loadNibNamed(NSNib.Name(rawValue: nibName), owner: self, topLevelObjects: &topLevelObjects) {
            let foundView = topLevelObjects!.first(where: { $0 is NSView }) as? NSView
            guard let view = foundView else { return nil }
            
            self.addSubview(view)
            view.wantsLayer = true
            view.translatesAutoresizingMaskIntoConstraints = true
            view.autoresizingMask = [.width, .height]
            view.frame = self.bounds
            
            return view
        }
        return nil
    }
}
