//
//  CPKeySignatureLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/19/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

//TODO: Key changes

final class CPKeySignatureLayer : CPLayer, CPGlyphRepresentable {
    
    static let circleOfFourths = ["B", "E", "A", "D", "G", "C", "F"]
    
    public var numberOfSharps : Int!
    public var mode: CPKeySignatureMode! //don't know what this is for yet
    
    public lazy var glyphRect : CGRect? = CGRect()
    
    init(_ numberOfSharps: Int, mode: CPKeySignatureMode) {
        super.init()
        self.numberOfSharps = numberOfSharps
        self.mode = mode
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // we will need to know the previous key signature for key changes to adjust
    // TODO: we need to know clef in order to place accidentals accordingly
    // note: some accidentals will need to drop octaves depending on the clef
    // i think we can handle this by putting checks in if they are out of the system, if so, adjust the octave
    public func layout(_ clef: CPClefLayer) {
        //this is where we will set the symbols and their locations based on the number of accidentals
        if numberOfSharps == 0 { return }
        // now that we have an instance of the clef we will do the layout
        // check octave
        let isSharpKey = numberOfSharps > 0
        let layer = CALayer()
        layer.backgroundColor = NSColor.cyan.cgColor
        
        let mesSpacing = (frame.size.height / 4)
        var originOfClefPosition = mesSpacing * CGFloat(2 - 1)
        // TODO: we still need to additional calculation for c clef I belive
        // also octave clef
        let transpotionSpacing = CGFloat(CPPitchLetter(rawValue: clef.sign.rawValue).octaveNeutralWholeToneDistance(toPitch: .c)) * mesSpacing
        
        
        CPDebugger.show(originOfClefPosition)
        layer.frame = CGRect(x: 0, y: originOfClefPosition, width: 50, height: 50)
        addSublayer(layer)   
        let halfFrame = frame.height * 0.5
        var xPos : CGFloat = 0
        var initialOffset : CGFloat =  0.0
        for var i in 0..<abs(numberOfSharps) {
            let accidental = CPAccidentalLayer(isSharpKey ? .sharp : .flat)
            accidental.frame = CGRect(x: xPos, y: 0, width: frame.width, height: frame.height)
            if i == 0 {
                initialOffset = abs(accidental.frame.origin.x - accidental.glyphRect!.origin.x)
            }
            //DEBUG:           
            var octave = 4
            
            
            var proposedY = CPMusicRenderingHelper.yPosition(pitch: CPPitch(step: CPPitchLetter(rawValue: CPKeySignatureLayer.circleOfFourths[i]), octave: octave), measureFrame: frame) + transpotionSpacing
            
            //F - flat looks ok in bass clef
            // however treble clef may want to bring the accidentals
            // there may be some specific behavior here that is required
            // not necessarily an accidental that is inside the staff
            // also TODO: out of bounds if fifths > 7 ( not a high priority obviously )
            
            //if it's too low
            while proposedY <= 0 {
                octave += 1
                proposedY = CPMusicRenderingHelper.yPosition(pitch: CPPitch(step: CPPitchLetter(rawValue: CPKeySignatureLayer.circleOfFourths[i]), octave: octave), measureFrame: frame) + transpotionSpacing
            }
            //if it's too high :)
            //Note, this might not be right, but it works for treble and bass clef and alto clef
            
            // <--- WHAT WE NEED TO DO NEXT -->
            //OOKKK so instead of checking against the bounds of measure,
            // we keep track of the previous clef y Position and transpose the octave that way :)
            // Don't forget about sharp keys either :P
            while proposedY + accidental.frame.height * 0.5 >= frame.height  {
                octave -= 1
                proposedY = CPMusicRenderingHelper.yPosition(pitch: CPPitch(step: CPPitchLetter(rawValue: CPKeySignatureLayer.circleOfFourths[i]), octave: octave), measureFrame: frame) + transpotionSpacing
            }
            
            
            accidental.frame.origin.y = proposedY
            xPos += accidental.glyphRect!.width
            addSublayer(accidental)
        }
        
        glyphRect!.size.width = xPos + initialOffset * 2
       // frame.origin.x += 500
        
    }
    
}

enum CPKeySignatureMode : String {
    case major, minor
    
    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "major":
            self = .major
            break
        case "minor":
            self = .minor
            break
        default:
            self = .major
        }
    }
}
