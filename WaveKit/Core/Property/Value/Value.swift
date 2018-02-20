//
//  Value.swift
//  WaveKit
//
//  Created by Leonardo Ascione on 20/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation
import AudioKit

/// Protocollo per la gestione delle proprietà
public enum Value {
    case double(Double?)
    case int(Int?)
    case wave(AKNode?)
    case none
}

