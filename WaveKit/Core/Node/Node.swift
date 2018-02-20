//
//  Node.swift
//  WaveKit
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Rappresenta un Nodo Audio nella composizione di un Playback.
open class Node : Hashable {
    public var id:NSUUID = NSUUID()
    
    /// Display Name di questo nodo, per la visualizzazione
    public var name:String
    
    /// Elenco delle proprietà.
    /// Viene definito dinamicamente dalle implementazioni specifiche.
    public var props:[Property] { return [] }
    
    /// Costruttore interno. Utilizzare le sottoclassi quando si usa
    /// come libreria
    init(name:String) {
        self.name = name
    }
    
    public var inputs:[Input] {
        return props.filter({ $0 is Input }).map({ return $0 as! Input })
    }
    
    public var outputs:[Output] {
        return props.filter({ $0 is Output }).map({ return $0 as! Output })
    }
    
    // MARK: Hashable
    
    public var hashValue: Int {
        return id.hash
    }
    
    public static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}

/// Rende il nodo disegnabile nella board
extension Node : BoardItem {
    public var itemType: BoardItemType {
        return BoardItemType.node
    }
    
    public var itemId: String {
        return id.uuidString
    }
}