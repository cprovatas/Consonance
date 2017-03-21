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
        borderColor = NSColor.red.cgColor
        borderWidth = 2
        
        var spacing = CPMusicRenderingHelper.yPosition(clef, measureFrame: frame) //get baseline and convert to our point
        spacing += frame.height * (9 / 8)
        
        var xPos : CGFloat = 0
        var initialOffset : CGFloat =  0.0
        for var i in 0..<abs(numberOfSharps) {
            let accidental = CPAccidentalLayer(isSharpKey ? .sharp : .flat)
            accidental.frame = CGRect(x: xPos, y: 0, width: frame.width, height: frame.height)
            if i == 0 {
                initialOffset = abs(accidental.frame.origin.x - accidental.glyphRect!.origin.x)
            }
            //DEBUG:
            accidental.borderColor = NSColor.yellow.cgColor
            accidental.borderWidth = 2
            var octave = 4
            
            var proposedY = CPMusicRenderingHelper.yPosition(pitch: CPPitch(step: CPPitchLetter(rawValue: CPKeySignatureLayer.circleOfFourths[i]), octave: octave), measureFrame: frame) + spacing
            
            //F - flat looks ok in bass clef
            // however treble clef may want to bring the accidentals
            // there may be some specific behavior here that is required
            // not necessarily an accidental that is inside the staff
            // also TODO: out of bounds if fifths > 7 ( not a high priority obviously )
            while proposedY - spacing <= 0 {
                proposedY = CPMusicRenderingHelper.yPosition(pitch: CPPitch(step: CPPitchLetter(rawValue: CPKeySignatureLayer.circleOfFourths[i]), octave: octave), measureFrame: frame) + spacing
                octave += 1
            }
            Swift.print(proposedY)
            
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
