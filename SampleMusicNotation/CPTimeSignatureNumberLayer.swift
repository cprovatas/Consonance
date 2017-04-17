//
//  CPTimeSignatureNumberLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 4/16/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

final class CPTimeSignatureNumberLayer : CPGlyphLayer {
    
    convenience init(_ number: Int) {
        self.init()
        if let glyphNum = CPTimeSignatureNumberLayer.glyph(forNumber: number) {
            glyphAsString = glyphNum
        }
    }
    
    private class func glyph(forNumber num: Int) -> String? {
        if num > 10 || num < 0 { return nil }
        let glyphs : [String] = ["", "", "", "", "", "", "", "", "", ""] // all time sig num glyphs from 0 - 10
        return glyphs[num - 1]
    }
    
}
