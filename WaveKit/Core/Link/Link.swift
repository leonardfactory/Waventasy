//
//  Link.swift
//  WaveKit
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Rappresenta un collegamento fra un Input e un Output di due nodi.
open class Link : Hashable {
    public var id:NSUUID = NSUUID()
    
    /// Nodo sorgente
    public var source:Node
    /// Proprietà in uscita, quindi sorgente, del link
    public var sourceProp:Output
    /// Nodo di destinazione
    public var target:Node?
    /// Proprietà in ingresso, quindi la destinazione, del link
    public var targetProp:Input?
    
    public init(source:Node, sourceProp:Output, target:Node?, targetProp:Input?) {
        self.source = source
        self.sourceProp = sourceProp
        self.target = target
        self.targetProp = targetProp
    }
    
    public convenience init(source:Node, sourceProp:Output) {
        self.init(source: source, sourceProp: sourceProp, target: nil, targetProp: nil)
    }
    
    // MARK: Hashable
    
    public var hashValue: Int {
        return id.hash
    }
    
    public static func ==(lhs: Link, rhs: Link) -> Bool {
        return lhs.id == rhs.id
    }
}

/// Rende il nodo disegnabile sulla Board
extension Link : BoardItem {
    public var itemType: BoardItemType {
        return BoardItemType.link
    }
    
    public var itemId: String {
        return id.uuidString
    }
}
