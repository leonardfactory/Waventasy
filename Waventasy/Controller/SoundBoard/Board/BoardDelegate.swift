//
//  BoardDelegate.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import Cocoa

public protocol BoardDelegate {
    // Dragging
    var isScrollViewDragging: Bool { get }
    // Mouse move per il linking
    func boardView(_ boardView:BoardView, mouseMoved:NSEvent) -> Void
    // Item dragging
    func boardView(_ boardView:BoardView, mouseDraggedForItem itemView:BoardItemView) -> Void
}
