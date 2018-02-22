//
//  BoardItemType.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Identificatore
public typealias BoardItemIdentifier = String

/// Tipi di elemento che possono apparire sulla Board
public enum BoardItemType: String {
    case node = "Node"
    case link = "Link"
}
