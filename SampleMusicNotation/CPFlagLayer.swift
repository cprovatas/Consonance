//
//  CPFlagLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/12/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa


final class CPFlagLayer : CPGlyphLayer {    
    //TODO: lengths shorter than 16th
    convenience init(duration: CPNoteLayerDurationType) {
        self.init()
        self.glyphAsString = CPFlagLayer.flagGlyph(forDuration: duration)        
    }
    
    private class func flagGlyph(forDuration duration: CPNoteLayerDurationType) -> String {
        switch duration {
        case .eighth:
            return ""
        case .sixteenth:
            return ""
        default:
            return ""
        }
    }
    
}
