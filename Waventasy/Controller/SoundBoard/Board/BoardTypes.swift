//
//  BoardTypes.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

public typealias BoardItemIdentifier = String
public typealias BoardItemType = String

public protocol BoardRenderable {
    var boardType: BoardItemType { get }
    var boardIdentifier: BoardItemIdentifier { get }
}
