//
//  NodeListDecoder.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 03/03/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

class NodeListDecoder : Codable {
    var list:[Node] = []
    
    init() {}
    
    /// Decoder che applica direttamente la sottoclasse necessaria
    required init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        if let count = container.count {
            list.reserveCapacity(count)
        }
        
        var containerForTypes = container
        
        while !container.isAtEnd {
            let nested = try containerForTypes.nestedContainer(keyedBy: Node.NodeCodingKeys.self)
            let nodeType = try nested.decode(NodeType.self, forKey: .type)
            switch (nodeType) {
                case .frequency: list.append(try container.decode(FrequencyNode.self))
                case .harmonic: list.append(try container.decode(HarmonicNode.self))
                case .constant: list.append(try container.decode(ConstantNode.self))
            }
        }
    }
}
