//
//  Extensions.swift
//  SampleMusicNotation
//
//  Created by Charlton Provatas on 1/22/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import AppKit

public extension NSBezierPath {
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveToBezierPathElement: path.move(to: CGPoint(x: points[0].x, y: points[0].y) )
            case .lineToBezierPathElement: path.addLine(to: CGPoint(x: points[0].x, y: points[0].y) )
            case .curveToBezierPathElement: path.addCurve(      to: CGPoint(x: points[2].x, y: points[2].y),
                                                                control1: CGPoint(x: points[0].x, y: points[0].y),
                                                                control2: CGPoint(x: points[1].x, y: points[1].y) )
            case .closePathBezierPathElement: path.closeSubpath()
            }
        }
        return path
    }
}

public extension AffineTransform {
    public init(rotationInDegrees degrees: CGFloat, aroundCenterOfRect rect: CGRect)  {
        self.init()
        self.translate(x: rect.origin.x + rect.size.width * 0.5, y: rect.origin.y + rect.size.height * 0.5)
        self.rotate(byDegrees: degrees)
        self.translate(x: -(rect.origin.x + rect.size.width * 0.5), y: -(rect.origin.y + rect.size.height * 0.5))
    }
}

public extension String {
    public var cgFloat : CGFloat {
        get {
            return CGFloat(NumberFormatter().number(from: self) ?? 0.0)
        }
    }
    
    public var int : Int {
        get {
            return Int(NumberFormatter().number(from: self) ?? 0)
        }
    }
}
