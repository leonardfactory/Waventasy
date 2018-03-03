//
//  Output.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Una proprietà in uscita dal Nodo
public class Output : Property {
    public init(key: String, name: String, value: Value) {
        super.init(.output, key: key, name: name, value: value)
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
