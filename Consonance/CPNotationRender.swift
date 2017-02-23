//
//  CPNoteRender.swift
//  SampleMusicNotation
//
//  Created by Charlton Provatas on 1/22/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import AppKit

final class CPNotationRender {
    
    public class func drawStem(fromPoint p1: CGPoint, toY y: CGFloat) -> CALayer {
        
        let path = NSBezierPath()
        path.move(to: p1)
        path.line(to: NSPoint(x: p1.x, y: y))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = NSColor.black.cgColor
        layer.lineWidth = 3.5
        layer.fillColor = NSColor.clear.cgColor
        return layer
    }
    
    public class func drawFilledOval(inRect rect: CGRect) -> CPNoteHeadLayer {
        let r = CGRect(x: 0, y: 0, width: rect.size.height * 0.6842105263, height: rect.size.height)
        let ellipsePath = NSBezierPath(ovalIn: r)
        ellipsePath.transform(using: AffineTransform(rotationInDegrees: -45, aroundCenterOfRect: r))
        let shapeLayer = CPNoteHeadLayer()
        shapeLayer.path = ellipsePath.cgPath
        shapeLayer.fillColor = NSColor.black.cgColor
        shapeLayer.strokeColor = NSColor.black.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: r.size.width, height: r.size.height)
        
        shapeLayer.endPoint = CGPoint(x: shapeLayer.frame.maxX + r.size.width * 0.16, y: rect.maxY - rect.size.height * 0.35)
        return shapeLayer
    }
    
    public class func drawMeasure(inRect rect: CGRect) -> CPMeasureLayer {
        
        let path = NSBezierPath()
        path.lineWidth = 10
        let spacing = rect.size.height / 4
        var point = CGPoint(x: 0, y: rect.size.height)
        path.move(to: point)
        point.y = 0
        path.line(to: point)
        point.x = rect.size.width
        path.line(to: point)
        point.y += spacing
        path.line(to: point)
        point.x = 0
        path.line(to: point)
        
        point.y += spacing
        path.move(to: point)
        point.x = rect.size.width
        path.line(to: point)
        point.y -= spacing
        path.line(to: point)
        point.y += spacing
        path.move(to: point)
        point.y += spacing
        path.line(to: point)
        point.x = 0
        path.line(to: point)
        point.x = rect.size.width
        path.move(to: point)
        point.y += spacing
        path.line(to: point)
        point.x = 0
        path.line(to: point)
        point.y = 0
        path.line(to: point)
        
        
        let shapeLayer = CPMeasureLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = NSColor.clear.cgColor
        shapeLayer.strokeColor = NSColor.black.cgColor
        shapeLayer.lineWidth = 2.5
        shapeLayer.frame = rect
        shapeLayer.boundingNoteSpacingHeight = spacing
        shapeLayer.fullNoteSectionHeight = spacing + 4
        
        return shapeLayer
    }
    
}
