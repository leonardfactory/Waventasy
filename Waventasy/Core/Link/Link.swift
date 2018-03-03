//
//  Link.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Rappresenta un collegamento fra un Input e un Output di due nodi.
open class Link : Hashable, Codable {
    public var id:UUID = UUID()
    
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
    
    // Codable
    // -
    
    private enum CodingKeys : CodingKey {
        case source, sourceProp, target, targetProp
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(source.id, forKey: .source)
        try container.encode(sourceProp.id, forKey: .sourceProp)
        try container.encode(target?.id, forKey: .target)
        try container.encode(targetProp?.id, forKey: .targetProp)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nodes = decoder.userInfo[NodeGraph.nodesKey] as? NodeListDecoder
        
        print("Nodes are", nodes?.list ?? "<na>")
        
        let sourceId = try container.decode(UUID.self, forKey: .source)
        let sourcePropId = try container.decode(UUID.self, forKey: .sourceProp)
        source = (nodes?.list.first { $0.id == sourceId })!
        sourceProp = (source.outputs.first { $0.id == sourcePropId })!
        
        let targetId = try container.decode(UUID?.self, forKey: .target)
        let targetPropId = try container.decode(UUID?.self, forKey: .targetProp)
        target = nodes?.list.first { $0.id == targetId }
        targetProp = target?.inputs.first { $0.id == targetPropId }
    }
    
    // MARK: Hashable
    
    public var hashValue: Int {
        return id.hashValue
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
