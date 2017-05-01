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
    
    private static let flatKeyLayoutDictionary : [CPClef : [Int]] = [CPClef(line: 2, sign: .treble) : [1, 4, 0, 3, -1, 2, -2],
                                                                               CPClef(line: 1, sign: .treble): [-1, 2, -2, 1, -3, 0, -4],
                                                                               CPClef(line: 4, sign: .bass): [-1, 2, -2, 1, -3, 0, -4],
                                                                               CPClef(line: 3, sign: .bass): [3, 0, 3, -1, 2, -2, 1],
                                                                               CPClef(line: 3, sign: .alto): [0, 3, -1, 2, -2, 1, -3],
                                                                               CPClef(line: 4, sign: .alto): [2, 5, 1, 4, 1, 3, -1],
                                                                               CPClef(line: 5, sign: .alto): [4, 0, 3, -1, 2, -2, 1],
                                                                               CPClef(line: 2, sign: .alto): [5, 1, 4, 0, 3, -1, 2],
                                                                               CPClef(line: 1, sign: .alto): [3, -1, 2, -2, 1, -3, 0],
                                                                               ]
    
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
        let model = CPClef(line: clef.line, sign: clef.sign)
        guard let accidentalLinePositions = CPKeySignatureLayer.flatKeyLayoutDictionary[model] else {
            return
        }
        
        // now that we have an instance of the clef we will do the layout
        // check octave
        let keyType : CPAccidentalLayerType = (numberOfSharps > 0 ? .sharp : .flat)
        
        //now set accidentals
        var xPos : CGFloat = 0
        let numberOfAccidentals = abs(numberOfSharps) > accidentalLinePositions.count ? accidentalLinePositions.count : abs(numberOfSharps)
        let noteSpacing = frame.height / 8
        for i in 0..<numberOfAccidentals {
            let accidental = CPAccidentalLayer(type: keyType)
            let yPos = (CGFloat(accidentalLinePositions[i]) * noteSpacing)
            accidental.frame = CGRect(x: xPos, y: yPos, width: frame.width, height: frame.height)
            
            addSublayer(accidental)
            xPos += accidental.glyphRect!.width            
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
