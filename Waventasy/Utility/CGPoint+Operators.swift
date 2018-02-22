//
//  CGPoint+Operators.swift
//  Waventasy
//
//  Created by Leonardo Ascione on 17/02/18.
//  Copyright © 2018 Leonardo Ascione. All rights reserved.
//

import Foundation

extension CGPoint {
    // Operazioni fra CGPoint
    // -
    
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
    
    func floor() -> CGPoint {
        return CGPoint(x: Darwin.floor(self.x), y: Darwin.floor(self.y))
    }
    
    func distance(p: CGPoint) -> CGFloat {
        let dx = x - p.x
        let dy = y - p.y
        return sqrt(dx*dx + dy*dy)
    }
    
    // Operazioni su CGFloat
    // -
    
    static func /(left:CGPoint, right:CGFloat) -> CGPoint {
        return CGPoint(x:left.x / right, y: left.y / right)
    }
    
    // Operazioni su CGSize
    // -
    
    static func -(left: CGPoint, right: CGSize) -> CGPoint {
        var sum = CGPoint()
        sum = CGPoint(x: left.x - right.width, y:left.y - right.height)
        return sum
    }
    
    static func /(left:CGPoint, right:CGSize) -> CGPoint {
        return CGPoint(x:left.x / right.width, y: left.y / right.height)
    }
    
    static func *(left:CGPoint, right:CGSize) -> CGPoint {
        return CGPoint(x:left.x * right.width, y: left.y * right.height)
    }
    
}

extension CGSize {
    static func /(left:CGSize, right:CGFloat) -> CGSize {
        return CGSize(width:left.width / right, height: left.height / right)
    }
}

extension NSRect {
    func center() -> CGPoint {
        return CGPoint(x: NSMidX(self), y: NSMidY(self))
    }
}
