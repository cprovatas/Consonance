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
//TODO: octave jumping needs to be handled

// The way key signatures are generated appears to be inherently messy,
// there is not really much in which this can be implemented in a systematic way.
// Composers I think draw key signatures based on what looks best and
// what generally stays within the staff

final class CPKeySignatureLayer : CPLayer, CPGlyphRepresentable {
    
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
    
    // i think this implementation is working, need to handle percussion clefs 8va, etc.. shouldn't be too bad hopefully..
    //NOTE: non harmonic-clefs should not show a key signature I think,
    //however finale does by default.. weird
    public func layout(_ clef: CPClefLayer) {
        if numberOfSharps == 0 ||
             clef.sign == .tab ||
             clef.sign == .percussion { return }
        // now that we have an instance of the clef we will do the layout
        // check octave
        let isSharpKey = numberOfSharps > 0
        
        let noteHeightSpacing : CGFloat = frame.height / 8
        let wholeToneOffset = clef.getKeySignaturePitchOffsetInWholeTones() //will offset the base note based on the clef
        let transpositionSpacing = wholeToneOffset * noteHeightSpacing //multiple by overall spacing
        
        var intervalSet = isSharpKey ? [4, -3] : [-4, 3] //the intervals in which the notes will move based on the key type
        
        var initialNote = isSharpKey ? CPPitch(step: .e, octave: 5) : CPPitch(step: .b, octave: 4) // change base pitch if it's sharp or not
        // determine base pitch
        if wholeToneOffset < -1 && !isSharpKey { //jump octaves if base pitch is too low
            
            initialNote.octave += 1
            intervalSet.reverse()
            
        }else if wholeToneOffset > 1 {
            
            if isSharpKey && clef.sign == .alto {
                initialNote.octave -= 1
                if wholeToneOffset == 2 {
                    intervalSet.reverse()
                }
            }
        }
        
        //now set accidentals
        var xPos : CGFloat = 0
        for var i in 0..<abs(numberOfSharps) {
            let accidental = CPAccidentalLayer(isSharpKey ? .sharp : .flat)
            accidental.frame = CGRect(x: xPos, y: 0, width: frame.width, height: frame.height)
            
            if i != 0 {
                initialNote = initialNote.transposedByWholeToneAmount(intervalSet[i % 2]) //move up or down by forth or 5th from previous note
                //<-- these are all specific cases depending on the clef, it might be better to hard code this later
                if CPMusicRenderingHelper.yPosition(pitch: initialNote, measureFrame: frame) + transpositionSpacing >=
                    frame.height * (1 / 2) {
                    if (clef.sign == .treble &&
                        (clef.line != 2 || (isSharpKey && i > 2))) ||
                        (clef.sign == .alto && clef.line != 4 && clef.line != 2 && (i > 2 || !isSharpKey)) ||
                        clef.sign == .bass ||
                        (clef.sign == .noClef && i > 3) { //lots of random cases here, key signature drawing makes no sense, i think it actually might be better to hard code all the cases
                        
                            initialNote.octave -= 1
                            intervalSet.reverse()
                    }
                }
            }
            
            accidental.frame.origin.y = CPMusicRenderingHelper.yPosition(pitch: initialNote, measureFrame: frame) + transpositionSpacing
            xPos += accidental.glyphRect!.width
            addSublayer(accidental)
        }
        glyphRect!.size.width = xPos
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
