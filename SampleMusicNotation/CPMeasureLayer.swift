//
//  CPMeasureLayer.swift
//  SampleMusicNotation
//
//  Created by Charlton Provatas on 1/28/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import AppKit


final class CPMeasureLayer : CAShapeLayer {
    
    public var number : Int!
    public var notes : [CPNoteLayer] = [] {
        didSet {
            layoutNotes()
        }
    }
    
    convenience init(frame: CGRect) {
        self.init()
        layout(frame)
    }
    
    private func layoutNotes() {
        for note in notes {
            //TODO: handle multiple pitches            
            
        }
    }
    
    private func renderNote(inMeasure measure: CALayer, atXPosition x: CGFloat) {
        let noteLayer = CPGlyphLayer(glyphAsString: "")
        noteLayer.frame = CGRect(x: x, y: 0 - ((measure.frame.size.height / 4) * 1.5), width: measure.frame.size.width, height: measure.frame.height)
        
        
        measure.addSublayer(noteLayer)
        
        let flag = CPGlyphLayer(glyphAsString: "")
        
        let point = CGPoint(x: noteLayer.glyphRect!.origin.x + ((noteLayer.anchorAttributes!.stemUpSE!.x * noteLayer.fontSize!) / 4), y: (noteLayer.glyphRect!.origin.y + (noteLayer.anchorAttributes!.stemUpSE!.y * noteLayer.fontSize!) / 4))
        
        let stem = CPStemLayer(fromPoint: point, toYPosition: point.y + (measure.frame.height / 4) * 3.25)
        noteLayer.addSublayer(stem)
        
        let fr = measure.bounds
        flag.frame = CGRect(x: noteLayer.glyphRect!.width + x, y: 0, width: fr.width, height: fr.height - fr.height / 6)
        
        measure.addSublayer(flag)
        
        flag.frame.origin.x -= abs(flag.glyphRect!.maxX - noteLayer.glyphRect!.maxX)
        flag.frame.origin.x -= 2.5
        
        flag.frame.origin.y = (noteLayer.convert(stem.maxYPoint, to: measure).y - (flag.frame.height - ((flag.frame.height - flag.glyphRect!.height) * 0.5)))
    }

    
    private func layout(_ frame: CGRect) {
        shouldRasterize = true
        contentsScale = CPGlobals.contentScaleFactor
        rasterizationScale = CPGlobals.contentScaleFactor
        
        
        let rect = frame
        let path = NSBezierPath()
        path.lineWidth = 1
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
        
        
        self.path = path.cgPath
        fillColor = NSColor.clear.cgColor
        strokeColor = NSColor.black.cgColor
        lineWidth = 1
        self.frame = rect
    }
}
