//
//  BoardItemView.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 18/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Cocoa

protocol BoardItemViewDelegate {
    func toGridPoint(point:CGPoint) -> CGPoint
}

extension BoardItemViewDelegate {
    func toGridPoint(point:CGPoint) -> CGPoint { return point }
}

public class BoardItemView: NSView {
    var delegate:BoardItemViewDelegate? = nil
}
