//
//  CPClefLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/6/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

class CPClefLayer : CPGlyphLayer {
    public var sign : CPClefLayerSign!
    //TODO : maybe make this a type later
    //TODO : clef changes
    public var line : Int = 0
    
    convenience init(_ sign: CPClefLayerSign, _ line: Int) {
        self.init()
        self.sign = sign
        self.line = line
        self.glyphAsString = sign.glyph
        self.fontScalingMode = .zeroFontSideBearings
    }
}


public enum CPClefLayerSign : String {
    
    case bass = "F"
    case treble = "G"
    
    public init(rawValue: String) {
        switch rawValue.lowercased() {
            case "f":
                self = .bass
            break
            case "g":
                self = .treble
            break
        default:
            self = .bass
            break            
        }
    }
    // //8va gclef
    
    // //normal gclef
    public var glyph : String {
        get {
            switch self {
            case .treble:
                return ""
            case .bass:
                return ""
            default:
                return ""
            }
        }
    }
}
