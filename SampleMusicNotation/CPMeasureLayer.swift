//
//  CPMeasureLayer.swift
//  SampleMusicNotation
//
//  Created by Charlton Provatas on 1/28/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import AppKit


final class CPMeasureLayer : CPLayer {
    
    public var number : Int!
    public var notes : [CPNoteLayer] = [] {
        didSet {
            layoutNotes()
        }
    }
    
    override var frame: CGRect {
        didSet {
            layout(self.frame)
            layoutNotes()
        }
    }
    
    convenience init(frame: CGRect) {
        self.init()
        layout(frame)
    }
    
    private func layoutNotes() {
        if frame.height == 0 || frame.width == 0 { return }
        
        for var i in 0..<notes.count {
            let note = notes[i]
            let yPos = yPosition(pitches: note.pitches)
            let xPos = ((frame.size.width / CGFloat(notes.count)) * CGFloat(i) - frame.size.width * 0.5)
            note.frame = CGRect(x: xPos, y: yPos, width: frame.size.width, height: frame.height)
            note.frame.origin.x += note.glyphRect!.width * 0.7
            
            if note.shouldHaveStem {
                layoutStem(forNote: note)
                if note.type.shouldHaveFlag {
                    layoutFlags(forNote: note)
                }
            }
            addSublayer(note)
        }
    }
    
    /* measure layer should manage this since it needs to connect separate notes depending on context */
    /* we will probably make a class out of this later as it gets more involved...                    */
    private func layoutFlags(forNote note: CPNoteLayer) {
        let flag = CPGlyphLayer(glyphAsString: "")
        let point = CGPoint(x: note.glyphRect!.origin.x + ((note.anchorAttributes!.stemUpSE!.x * note.fontSize!) / 4), y: (note.glyphRect!.origin.y + (note.anchorAttributes!.stemUpSE!.y * note.fontSize!) / 4))
        let fr = bounds
        flag.frame = CGRect(x: note.glyphRect!.width + note.frame.origin.x, y: 0, width: fr.width, height: fr.height - fr.height / 6)
        
        flag.frame.origin.x -= abs(flag.glyphRect!.maxX - note.glyphRect!.maxX)
        flag.frame.origin.x -= 2.5
        //TODO pitch calculation
       // flag.frame.origin.y = (note.convert(stem.maxYPoint, to: self).y - (flag.frame.height - ((flag.frame.height - flag.glyphRect!.height) * 0.5)))
        
        addSublayer(flag)
    }
    
    private func layoutStem(forNote note: CPNoteLayer) {
        //TODO : eights aren't working
        let point = CGPoint(x: note.glyphRect!.origin.x + ((note.anchorAttributes!.stemUpSE!.x * note.fontSize!) / 4), y: (note.glyphRect!.origin.y + (note.anchorAttributes!.stemUpSE!.y * note.fontSize!) / 4))
        let stem = CPStemLayer(fromPoint: point, toYPosition: point.y + (frame.height / 4) * 3.25)
        note.addSublayer(stem)
    }
    
    private func yPosition(pitches: [CPPitch]) -> CGFloat {
        let spacing = frame.height / 8
        
        //TODO: multiple pitches
        //TODO: clef transposition
        if pitches.count < 1 { return 0.0 }
        let initialPitch = pitches[0]
        
        let baselineValue : CGFloat = (4.0 * 7.0) + 6
        let pitchValue : CGFloat = CGFloat(initialPitch.octave * 7) + CGFloat(initialPitch.step.intValue)
        Swift.print("octave: \(initialPitch.octave), step: \(initialPitch.step), pitchValue: \(pitchValue)")
        return -((baselineValue - pitchValue) * spacing)
    }
    
    private func layout(_ frame: CGRect) {
              
        contentsScale = CPGlobals.contentScaleFactor
        masksToBounds = false
        
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
    }
}
