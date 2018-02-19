//
//  BoardItemView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

protocol BoardItemViewDelegate {
    // Fissa i punti alla griglia, se necessario
    func toGridPoint(point:CGPoint) -> CGPoint
    // Controlla se è possibile far partire il drag&drop
    var canDragItem:Bool { get }
    // Monitoring del drag&drop
    func mouseDragged(forItem itemView:BoardItemView) -> Void
}

extension BoardItemViewDelegate {
    func toGridPoint(point:CGPoint) -> CGPoint { return point }
    var canDragItem:Bool { return true }
}

public class BoardItemView: NSView {
    var delegate:BoardItemViewDelegate? = nil
}
