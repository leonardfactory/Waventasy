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
    /// Elenco degli elementi nella Board
    func itemsIn(boardView: BoardView) -> [BoardItem]
    /// Dimensioni del Contenuto
    func contentRectFor(boardView: BoardView) -> NSRect
    
    /// Rendering degli elementi
    func boardView(_ boardView: BoardView, item:BoardItem, fromExistingView existingView:BoardItemView?) -> BoardItemView?
    /// All'avvio del link, ne segnala la creazione
    func boardView(_ boardView: BoardView, didStartLink link:Link) -> Link
    /// Al completamento di un Link, ne segnala l'aggiunta
    func boardView(_ boardView: BoardView, didCompleteLink link:Link) -> Void
}

// Default
extension BoardDataSource {
    
}
