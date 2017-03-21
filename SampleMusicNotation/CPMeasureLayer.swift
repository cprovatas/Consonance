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
    
    public var glyphs : [CPLayer] = [] {
        didSet {
            layout(frame)
        }
    }                
    
    override var frame: CGRect {
        didSet {
            layout(frame)
        }
    }
    
    private var currentClef : CPClefLayer!
    
    private func layoutGlyphs() {
        if frame.height == 0 || frame.width == 0 || glyphs.count == 0 { return }
        
        var xPos : CGFloat = 0
        for var i in 0..<glyphs.count {
            let glyph = glyphs[i]
            
            var glyphWidth = (frame.width - xPos) / CGFloat(glyphs.count - i)
            
            glyph.frame = CGRect(x: xPos, y: 0, width: glyphWidth, height: frame.height)
            
            //glyph.frame.origin.x += glyph.glyphRect!.width * 0.25
            glyph.borderWidth = 2
            glyph.borderColor = NSColor.blue.cgColor
            if glyph is CPNoteLayer {
                setUpNote(glyph as! CPNoteLayer)
            }else if glyph is CPClefLayer {
                setUpClef(glyph as! CPClefLayer)
                currentClef = glyph as! CPClefLayer
                glyph.borderColor = NSColor.red.cgColor
                
            }else if glyph is CPKeySignatureLayer {
                setUpKeySignature(glyph as! CPKeySignatureLayer)
            }
            
            if glyph is CPGlyphRepresentable { //contains a glyphRect
                if glyphWidth < (glyph as! CPGlyphRepresentable).glyphRect!.width {
                    let val = (glyph as! CPGlyphRepresentable).glyphRect!.width - glyphWidth
                    glyph.frame.size.width += val
                    xPos += val
                }
            }
            xPos += glyphWidth
            addSublayer(glyph)
                                 
        }
    }
    
    private func setUpKeySignature(_ keySig: CPKeySignatureLayer) {
        if currentClef == nil {
            currentClef = CPClefLayer(.treble, 4)
        }
        keySig.layout(currentClef)
    }
    
    private func setUpNote(_ note: CPNoteLayer) {
        if note.pitches.count < 1 { return }
        note.frame.origin.y = CPMusicRenderingHelper.yPosition(pitch: note.pitches[0], measureFrame: frame)
        if note.shouldHaveStem {
            layoutStem(forNote: note)
            if note.durationType.shouldHaveFlag {
                layoutFlags(forNote: note)
            }
        }
    }
    
    //TODO: may need to treat clef as a normal glyph as it can be positioned anywhere in the measure
    private func setUpClef(_ clef: CPClefLayer) {
        if (number != nil && number != 1) { return } //TODO: this probably is not the best way for now, but we need to learn how musicxml handles the redeclaration of clefs etc...
        
        
        //clef.frame.origin.x -= (bounds.size.width)
        
        clef.frame.size.height = frame.size.height * 4
  //      clef.frame.size.width = frame.size.width
      //  clef.frame.origin.x -= clef.frame.width * 0.5
      //  clef.frame.origin.x += clef.glyphRect!.width * 4.05
        clef.frame.origin.y = CPMusicRenderingHelper.yPosition(clef, measureFrame: frame)
        
        addSublayer(clef)
    }
    
    /* measure layer should manage this since it needs to connect separate notes depending on context */
    /* we will probably make a class out of this later as it gets more involved...                    */
    private func layoutFlags(forNote note: CPNoteLayer) {
        
        if note.stem == nil { return }
        
        let flag = CPFlagLayer(duration: note.durationType)
        let point = CGPoint(x: note.glyphRect!.origin.x + ((note.anchorAttributes!.stemUpSE!.x * note.fontSize!) / 4), y: (note.glyphRect!.origin.y + (note.anchorAttributes!.stemUpSE!.y * note.fontSize!) / 4))
        let fr = bounds
        flag.frame = CGRect(x: note.frame.origin.x, y: 0, width: fr.width, height: fr.height - fr.height / 6)
        
        flag.frame.origin.x -= flag.glyphRect!.maxX
        flag.frame.origin.x += ((flag.glyphRect!.width + note.glyphRect!.maxX) - 2.5)
        
        flag.frame.origin.y = (note.convert(note.stem!.maxYPoint, to: self).y - (flag.frame.height - ((flag.frame.height - flag.glyphRect!.height) * 0.5)))
        
        addSublayer(flag)
    }
    
    private func layoutStem(forNote note: CPNoteLayer) {
        
        let point = CGPoint(x: note.glyphRect!.origin.x + ((note.anchorAttributes!.stemUpSE!.x * note.fontSize!) / 4), y: (note.glyphRect!.origin.y + (note.anchorAttributes!.stemUpSE!.y * note.fontSize!) / 4))
        note.stem = CPStemLayer(fromPoint: point, toYPosition: point.y + (frame.height / 4) * 3.25)
        note.addSublayer(note.stem!)
    }

    
    //sets up a basic grid for the measures
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
        
        layoutGlyphs()
    }
}
