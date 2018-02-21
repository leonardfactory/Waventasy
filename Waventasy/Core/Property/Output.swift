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
}