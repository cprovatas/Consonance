//
//  CPClefLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/6/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

protocol CPClefRepresentable : Hashable, Equatable {
    var sign : CPClefLayerSign! { get set }
    var line : Int { get set }
    init(line: Int, sign: CPClefLayerSign, octaveOffsetDirection: CPClefLayerSignOctaveOffsetDirection?)
}

struct CPClef : CPClefRepresentable {
    
    var line : Int
    var sign : CPClefLayerSign!
    
    internal init(line: Int, sign: CPClefLayerSign, octaveOffsetDirection: CPClefLayerSignOctaveOffsetDirection?=nil) {
        self.line = line
        self.sign = sign
    }
}

extension CPClefRepresentable {
    
    var hashValue: Int { //hashable default implementation
        return 0
    }
}

func ==<T: CPClefRepresentable>(lhs: T, rhs: T) -> Bool { //Equatable protocol
    return lhs.line == rhs.line && lhs.sign == rhs.sign
}


fileprivate let clefDefaultLinePositions : [CPClefLayerSign : Int] = [.bass : 4, .treble : 2, .alto : 3] //stored default line values for clefs
class CPClefLayer : CPGlyphLayer, CPClefRepresentable {

    public var sign : CPClefLayerSign!
    //TODO : maybe make this a type later
    //TODO : clef changes
    
    // //normal gclef
    public var octaveOffsetDirection : CPClefLayerSignOctaveOffsetDirection?
    private var glyph : String {
        get {
            let hasOctaveOffset = octaveOffsetDirection != nil
            switch sign! {
            case .treble:
                return hasOctaveOffset ? octaveOffsetDirection!.glyph(forClefLayerSign: sign) : ""
            case .bass:
                return hasOctaveOffset ? octaveOffsetDirection!.glyph(forClefLayerSign: sign) : ""
            case .alto:
                return hasOctaveOffset ? octaveOffsetDirection!.glyph(forClefLayerSign: sign) : ""
            case .percussion: //TODO: percussion glyph is based on <key printObject=NO> element attribute
                return ""
            case .tab:
                return ""            
            case .noClef:
                return ""
            }
        }
    }
    //TODO: reduce flag size width
    //Note for the future: all clefs are nested in an <attributes> tag, including clef changes 
    public var line : Int = 0
    
    convenience required init(line: Int, sign: CPClefLayerSign, octaveOffsetDirection: CPClefLayerSignOctaveOffsetDirection?=nil) {
        self.init()
        self.sign = sign
        self.line = line
        self.octaveOffsetDirection = octaveOffsetDirection
        self.glyphAsString = glyph
        self.fontScalingMode = .naturalVerticalPosition        
        
        if sign == .noClef {
            glyphRect!.size.width = 0
            frame.size.width = 0
        }else if sign == .tab {
            self.line = 3
        }
    }
}


public enum CPClefLayerSign : String {
    
    case bass = "F"
    case treble = "G"
    case alto = "C"
    
    //non-harmonic clefs
    case percussion = "percussion"
    case tab = "tab"
    case noClef = "none"
    
    public init(rawValue: String) {
        switch rawValue.lowercased() {
            case "f":
                self = .bass
            break
            case "g":
                self = .treble
            break
            case "c":
                self = .alto
            case "none":
            self = .noClef
            break
            case "percussion":
            self = .percussion
            break
            case "tab":
            self = .tab
            break
        default:
            self = .noClef
            break
        }
    }
    // //8va gclef
}

public enum CPClefLayerSignOctaveOffsetDirection: Int {
    case up, down
    
    public init?(rawValue: Int) {
        if rawValue > 0 {
            self = .up
        }else if rawValue < 0 {
            self = .down
        }else {
            return nil
        }
    }
    
    public func glyph(forClefLayerSign sign: CPClefLayerSign) -> String {
        switch sign {
        case .treble:
            return self == .up ? "" : ""
        case .bass:
            return self == .up ? "" : ""
        case .alto:
            return self == .up ? "" : "" //NOTE: alto octave up change, couldn't find glyph for, perhaps is uncommon?
                                             //finale does not render 8va for alto
        default:
            return ""
        }
    }
}
