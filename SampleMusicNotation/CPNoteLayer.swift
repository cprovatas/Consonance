//
//  CPNoteLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/6/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa


class CPNoteLayer : CPGlyphLayer {
    
    public var pitches : [CPPitch] = []
    public var noteDuration : Int!
    public var voice : Int!
    public var durationType : CPNoteLayerDurationType!
    public var stemPosition : CPStemLayerPosition!
    public var explicitXPosition : CGFloat?
    public var stem : CPStemLayer? 
    
    public var shouldHaveStem : Bool {
        get {
            return durationType.shouldHaveStem && stemPosition != .none
        }
    }
    
    convenience init(pitches: [CPPitch], noteDuration: Int, voice: Int, type: CPNoteLayerDurationType, stemPosition: CPStemLayerPosition) {
        self.init()
        self.pitches = pitches
        self.noteDuration = noteDuration
        self.voice = voice
        self.durationType = type
        glyphAsString = type.glyph
        self.stemPosition = stemPosition
    }
}

enum CPNoteLayerDurationType : String {
    //TODO add other durations
    case whole = "whole"
    case half = "half"
    case quarter = "quarter"
    case eighth = "eighth"
    case sixteenth = "sixteenth"
    case thirtySecond = "thirtysecond"
    
    public var glyph : String {
        get {
            switch self {
            case .whole:
                return ""
            case .half:
                return ""
            case .quarter:
                return ""
            case .eighth:
                return ""
            case .sixteenth:
                return ""
            case .thirtySecond:
                return ""
            }
        }
    }
    
    public var shouldHaveFlag : Bool {
        get {
            return self == .eighth || self == .sixteenth
        }
    }
    
    public var shouldHaveStem : Bool {
        get {
            return self != .whole
        }
    }
    
    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "whole":
            self = .whole
            break
        case "half":
            self = .half
            break
        case "quarter":
            self = .quarter
            break
        case "eighth":
            self = .eighth
            break
        case "sixteenth":
            self = .sixteenth
            break
        default:
            self = .quarter
            break
        }
    }
}


