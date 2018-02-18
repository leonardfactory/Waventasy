//
//  BoardDataSource.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import Cocoa

public protocol BoardDataSource {
    // Numero degli elementi nella Board
    func boardView(itemsIn boardView: BoardView) -> [BoardRenderable]
    // Rendering degli elementi
    func boardView(_ boardView: BoardView, item:BoardRenderable, fromExistingView existingView:BoardItemView?) -> BoardItemView?
    // Dimensioni del Contenuto
    func boardView(contentSizeFor boardView: BoardView) -> NSSize
}

// Default
extension BoardDataSource {
    
}
