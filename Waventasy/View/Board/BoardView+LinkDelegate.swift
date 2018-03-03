//
//  BoardView+LinkDelegate.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 21/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

/// Gestione della visualizzazione Link sulla Board
extension BoardView : LinkViewDelegate {
    func color(forLink link: Link?) -> NSColor {
        return link?.target == nil
            ? LinkColors.activeLineColor
            : LinkColors.completeLineColor
    }
    
    func startingPoint(forLink link: Link?) -> CGPoint {
        if  let source = link?.source,
            let sourceView = self.view(forItem: source.itemId) as? NodeView,
            let sourceProp = link?.sourceProp,
            let sourcePropView = sourceView.outputSubviews[sourceProp]
        {
            return sourcePropView.convert(
                sourcePropView.linkButton.frame.center(),
                to: self
            )
        }
        
        return CGPoint.zero
        
        fatalError("Impossibile trovare lo slot")
    }
    
    func endingPoint(forLink link: Link?) -> CGPoint {
        if link?.target == nil {
            return self.activeLinkEnding ?? self.startingPoint(forLink:link)
        }
        
        if  let target = link?.target,
            let targetView = self.view(forItem: target.itemId) as? NodeView,
            let targetProp = link?.targetProp,
            let targetPropView = targetView.inputSubviews[targetProp]
        {
            return targetPropView.convert(
                targetPropView.linkButton.frame.center(),
                to: self
            )
        }
        
        return CGPoint.zero
    }
}
