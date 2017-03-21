//
//  CPAccidentalLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/19/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

final class CPAccidentalLayer : CPGlyphLayer {
    
    convenience init(_ type: CPAccidentalLayerType) {        
        self.init()
        glyphAsString = type.glyph
    }
}

enum CPAccidentalLayerType {
    //TODO: courtesy accidentals
    case sharp, flat, natural, doubleSharp, doubleFlat, tripleSharp, tripleFlat
    
    var glyph : String {
        get {
            switch self {
            case .flat:
                return ""
            case .sharp:
                return ""
            case .natural:
                return ""
            case .doubleFlat:
                return ""
            case .doubleSharp:
                return ""
            case .tripleSharp:
                return ""
            case .tripleFlat:
                return ""
            }
        }
    }
}
