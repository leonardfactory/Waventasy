//
//  Node.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Per comodità, rappresentiamo ogni subclass di Node con un Enum.
public enum NodeType : String, Codable {
    /// Frequenza
    case frequency
    /// Armonica
    case harmonic
    /// Costante
    case constant
}

/// Rappresenta un Nodo Audio nella composizione di un Playback.
open class Node : Hashable, Codable {
    public var id:UUID = UUID()
    
    /// Tipo di nodo
    public var type:NodeType
    
    /// Display Name di questo nodo, per la visualizzazione
    public var name:String
    
    /// Posizione del nodo (coordinate)
    public var position:CGPoint
    
    /// Elenco delle proprietà.
    /// Viene definito dinamicamente dalle implementazioni specifiche.
    public var props:[Property] { return [] }
    
    /// Costruttore interno. Utilizzare le sottoclassi quando si usa
    /// come libreria
    init(_ type:NodeType, name:String, position:CGPoint = CGPoint.zero) {
        self.type = type
        self.name = name
        self.position = position
    }
    
    public var inputs:[Input] {
        return props.filter({ $0 is Input }).map({ return $0 as! Input })
    }
    
    public var outputs:[Output] {
        return props.filter({ $0 is Output }).map({ return $0 as! Output })
    }
    
    // MARK: Resolver
    
    public func resolve(ctx:ResolveContext) throws {}
    
    // MARK: Hashable
    
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: Decoding
    
    public enum NodeCodingKeys : CodingKey {
        case id, type, name, position, props
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: NodeCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(position, forKey: .position)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NodeCodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(NodeType.self, forKey: .type)
        name = try container.decode(String.self, forKey: .name)
        position = try container.decode(CGPoint.self, forKey: .position)
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
