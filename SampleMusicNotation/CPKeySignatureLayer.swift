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
        
        
        let noteHeightSpacing : CGFloat = frame.height / 8

        let transpositionSpacing = clef.getKeySignaturePitchOffsetInWholeTones() * noteHeightSpacing
        
        
          // < -- this implementation we will use for determining the ordering of accidentals in the key sig declaration
        var intervalSet = isSharpKey ? [-3, 4] : [-4, 3]
        var initialNote = CPPitch(step: .b, octave: 4)
//        if CPMusicRenderingHelper.yPosition(pitch: initialNote, measureFrame: frame) < 0 {
//            initialNote.octave += 1
//        }
//        
//        if CPMusicRenderingHelper.yPosition(pitch: initialNote.transposedByWholeToneAmount(intervalSet[1]), measureFrame: frame) + transpositionSpacing >  frame.height {
//            intervalSet.reverse()
//        }
        
        var xPos : CGFloat = 0
        
        for var i in 0..<abs(numberOfSharps) {
            let accidental = CPAccidentalLayer(isSharpKey ? .sharp : .flat)
            accidental.frame = CGRect(x: xPos, y: 0, width: frame.width, height: frame.height)
            //F - flat looks ok in bass clef
            // however treble clef may want to bring the accidentals
            // there may be some specific behavior here that is required
            // not necessarily an accidental that is inside the staff
            // also TODO: out of bounds if fifths > 7 ( not a high priority obviously )
                // we need to do this calculation using transposition, it's the only vaiable way I think
                // we can really do it relative to the previous because of the relationships required...
            if i != 0 {
                initialNote = initialNote.transposedByWholeToneAmount(intervalSet[i % 2] )
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
