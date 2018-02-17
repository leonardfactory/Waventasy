//
//  CGPoint+Operators.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 17/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        var sum = CGPoint()
        sum = CGPoint(x: left.x + right.x, y: left.y + right.y)
        return sum
    }
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        var sum = CGPoint()
        sum = CGPoint(x: left.x - right.x, y:left.y - right.y)
        return sum
    }
    
    func distance(p: CGPoint) -> CGFloat {
        let dx = x - p.x
        let dy = y - p.y
        return sqrt(dx*dx + dy*dy)
    }
}
