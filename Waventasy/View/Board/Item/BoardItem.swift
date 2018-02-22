//
//  BoardItem.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

/// Protocollo che definisce le chiavi necessarie per il rendering sulla Board
/// di una qualsiasi classe.
public protocol BoardItem {
    /// Il tipo di elemento
    var itemType: BoardItemType { get }
    /// ID univoco (fra tutti gli elementi)
    var itemId: BoardItemIdentifier { get }
}
