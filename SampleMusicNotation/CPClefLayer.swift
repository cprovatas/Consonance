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
    public var line : Int = 0
}


public enum CPClefLayerSign : String {
    case bass = "F"
    case treble = "G"
}
