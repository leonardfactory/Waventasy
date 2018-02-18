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
    
    static func -(left: CGPoint, right: CGSize) -> CGPoint {
        var sum = CGPoint()
        sum = CGPoint(x: left.x - right.width, y:left.y - right.height)
        return sum
    }
    
    static func /(left:CGPoint, right:CGFloat) -> CGPoint {
        return CGPoint(x:left.x / right, y: left.y / right)
    }
    
    func distance(p: CGPoint) -> CGFloat {
        let dx = x - p.x
        let dy = y - p.y
        return sqrt(dx*dx + dy*dy)
    }
}

extension CGSize {
    static func /(left:CGSize, right:CGFloat) -> CGSize {
        return CGSize(width:left.width / right, height: left.height / right)
    }
}
