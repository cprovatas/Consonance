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
        glyphAsString = type.noteHeadGlyph
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
    
    public var rawValue: Int {
        get {
            switch self {
            case .whole:
                return 1
            case .half:
                return 2
            case .quarter:
                return 4
            case .eighth:
                return 8
            case .sixteenth:
                return 16
            case .thirtySecond:
                return 32        
            }
        }
    }
    
    public var noteHeadGlyph : String {
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
        case "thirtysecond":
            self = .thirtySecond
            break
        default:
            self = .quarter
            break
        }
    }
    
    init(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .whole
            break
        case 2:
            self = .half
            break
        case 4:
            self = .quarter
            break
        case 8:
            self = .eighth
            break
        case 16:
            self = .sixteenth
            break
        case 32:
            self = .thirtySecond
            break
        default:
            self = .quarter
            break
        }
    }
}


