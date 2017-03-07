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
    public var type : CPNoteLayerType!
    public var stemPosition : CPStemLayerPosition!
}

enum CPNoteLayerType : String {
    case whole = "whole"
    case half = "half"
    case quarter = "quarter"
    case eighth = "eighth"
    case sixteenth = "sixteenth"
}
