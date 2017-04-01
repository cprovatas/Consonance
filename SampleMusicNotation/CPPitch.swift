//
//  CPPitch.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/6/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa


struct CPPitch {
    fileprivate static let pitches : [CPPitchLetter] = [.c, .d, .e, .f, .g, .a, .b]
    public var step: CPPitchLetter!
    public var octave: Int
    
    
    // i think something i'm missing w/ tranposition, is the usefulness of the modulo operator
    // this is something i need apply to refactor some code
    // note: c is the base note, we may keep this the trend for all functions
    public func transposedByWholeToneAmount(_ amt: Int) -> CPPitch {
        
        var index = 0
        for var i in 0..<CPPitch.pitches.count {
            if CPPitch.pitches[i] == self.step {
                index = i
            }
        }
        
        var val = (index + amt) % 7
        if val < 0 { val += 7 }
        let divisor = ((index + amt) - val) / 7        
        
        return CPPitch(step: CPPitch.pitches[val], octave: octave + divisor)
    }
}

enum CPPitchLetter : String {
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case e = "E"
    case f = "F"
    case g = "G"
    
    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "a":
            self = .a
            break
        case "b":
            self = .b
            break
        case "c":
            self = .c
            break
        case "d":
            self = .d
            break
        case "e":
            self = .e
            break
        case "f":
            self = .f
            break
        case "g":
            self = .g
            break
        default:
            self = .a
            break
        }
    }
    
    public var intValue : Int {
        switch self {
        case .a:
            return 6
        case .b:
            return 7
        case .c:
            return 1
        case .d:
            return 2
        case .e:
            return 3
        case .f:
            return 4
        case .g:
            return 5
        }
    }
    
    //calculates how far a given pitch is away from another note, ignorning the octave, used for clef transposition
    public func octaveNeutralWholeToneDistance(toPitch pitch: CPPitchLetter) -> Int {
        var val = abs(self.intValue - pitch.intValue)
        while val > 3 {
            val -= 7
        }
        return val
    }
    
}
