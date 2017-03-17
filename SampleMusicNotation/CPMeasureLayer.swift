//
//  CPMeasureLayer.swift
//  SampleMusicNotation
//
//  Created by Charlton Provatas on 1/28/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import AppKit

//TODO: Clefs are next :)
final class CPMeasureLayer : CPLayer {
    
    public var number : Int!
    public var clef : CPClefLayer?
    public var notes : [CPNoteLayer] = [] {
        didSet {
            layout(frame)
        }
    }        
    
    override var frame: CGRect {
        didSet {
            layout(frame)
        }
    }
    
    private func layoutClef() {
        if (number != nil && number != 1) || clef == nil { return } //TODO: this probably is not the best way for now, but we need to learn how musicxml handles the redeclaration of measures etc...
        let h = frame.height
        clef!.frame.size = frame.size * 4
      //  clef!.frame.origin = NSPoint(x: -clef!.frame.width * 0.5, y: (-clef!.frame.height * 0.5)  + clef!.glyphRect!.height * 0.5)
        Swift.print(clef!.glyphRect)
        clef!.frame.origin = CGPoint(x: -1500, y: -366)
        clef!.frame.origin.y -= (frame.size.height / 8) - 7
        clef!.borderWidth = 5
        
        addSublayer(clef!)
        //Optional((1746.84310276196, 422.288872191222, 158.313794476077, 413.924608473909))
        //Optional((1746.84310276196, 448.203332596532, 158.313794476077, 465.753529284529))
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
                if note.durationType.shouldHaveFlag {
                    layoutFlags(forNote: note)
                }
            }
            addSublayer(note)
        }
    }
    
    /* measure layer should manage this since it needs to connect separate notes depending on context */
    /* we will probably make a class out of this later as it gets more involved...                    */
    private func layoutFlags(forNote note: CPNoteLayer) {
        
        if note.stem == nil { return }
        
        let flag = CPFlagLayer(duration: note.durationType)
        let point = CGPoint(x: note.glyphRect!.origin.x + ((note.anchorAttributes!.stemUpSE!.x * note.fontSize!) / 4), y: (note.glyphRect!.origin.y + (note.anchorAttributes!.stemUpSE!.y * note.fontSize!) / 4))
        let fr = bounds
        flag.frame = CGRect(x: note.glyphRect!.width + note.frame.origin.x, y: 0, width: fr.width, height: fr.height - fr.height / 6)
        
        flag.frame.origin.x -= abs(flag.glyphRect!.maxX - note.glyphRect!.maxX)
        flag.frame.origin.x -= 2.5
        
        flag.frame.origin.y = (note.convert(note.stem!.maxYPoint, to: self).y - (flag.frame.height - ((flag.frame.height - flag.glyphRect!.height) * 0.5)))
        
        addSublayer(flag)
    }
    
    private func layoutStem(forNote note: CPNoteLayer) {
        
        let point = CGPoint(x: note.glyphRect!.origin.x + ((note.anchorAttributes!.stemUpSE!.x * note.fontSize!) / 4), y: (note.glyphRect!.origin.y + (note.anchorAttributes!.stemUpSE!.y * note.fontSize!) / 4))
        note.stem = CPStemLayer(fromPoint: point, toYPosition: point.y + (frame.height / 4) * 3.25)
        note.addSublayer(note.stem!)
    }
    
    private func yPosition(pitches: [CPPitch]) -> CGFloat {
        let spacing = frame.height / 8
        
        //TODO: multiple pitches
        //TODO: clef transposition
        if pitches.count < 1 { return 0.0 }
        let initialPitch = pitches[0]
        
        let baselineValue : CGFloat = (4.0 * 7.0) + 6
        let pitchValue : CGFloat = CGFloat(initialPitch.octave * 7) + CGFloat(initialPitch.step.intValue)        
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
        
        
        layoutClef()
        layoutNotes()
    }
}
