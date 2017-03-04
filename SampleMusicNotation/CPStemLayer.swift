//
//  CPStem.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/1/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

final class CPStemLayer : CAShapeLayer {
    
    public var maxYPoint : CGPoint!
    public var minYPoint : CGPoint!
    
    convenience init(fromPoint p1: CGPoint, toYPosition y: CGFloat) {
        self.init()
        let path = NSBezierPath()
        let newP1 = NSPoint(x: p1.x - 1.25, y: p1.y)
        let p2 = NSPoint(x: p1.x - 1.25, y: y)
        path.move(to: newP1)
        path.line(to: p2)
        
        if p2.y > p1.y {
            minYPoint = p1
            maxYPoint = p2
        }else {
            maxYPoint = p1
            minYPoint = p2
        }                
        
        self.path = path.cgPath
        strokeColor = NSColor.black.cgColor
        lineWidth = 2.5
        backgroundColor = NSColor.green.cgColor
        fillColor = NSColor.yellow.cgColor
    }
    
}
