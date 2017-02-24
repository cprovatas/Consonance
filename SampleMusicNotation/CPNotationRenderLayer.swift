//
//  CPNotationRenderLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 2/22/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

class CPNotationRenderLayer : CALayer {
    
    public var glyphAsString : String? {
        didSet {
            
        }
    }
    
    convenience init(glyphAsString: String) {
        self.init()
        self.glyphAsString = glyphAsString
        setNeedsDisplay()
    }
    
    
    
    override func draw(in ctx: CGContext) {
        defer {
            free(characters)
            free(characterFrames)
            free(glyphs)
        }
        
        let len = glyphAsString!.characters.count
        let characters = UnsafeMutablePointer<UniChar>.allocate(capacity: len)
        let characterFrames =  UnsafeMutablePointer<CGRect>.allocate(capacity: 1)
        CFStringGetCharacters(glyphAsString as! CFString, CFRangeMake(0, len), characters)
        let glyphs = UnsafeMutablePointer<CGGlyph>.allocate(capacity: len)
        CTFontGetGlyphsForCharacters(CPFontManager.currentFont as CTFont, characters, glyphs, len)
        let rect = CTFontGetOpticalBoundsForGlyphs(CPFontManager.currentFont as CTFont, glyphs, characterFrames, len, CFOptionFlags.allZeros)
        //let customFont = CGFont("Bravura" as CFString)!
        
        //        let name = customFont.name(for: glyphs.pointee)!
        //        let glyphName = CPGlyphJSONSerialization.getFormattedGlyphName(forUnicodeGlyphName: name)
        //        let anchorAttributes = CPGlyphJSONSerialization.getGlyphAnchorAttributes(fromFormattedGlyphName: glyphName)
        //  print(anchorAttributes)
        //let rect = CTFontGetBoundingRectsForGlyphs(font as! CTFont, .default, glyphs, characterFrames, len)
        let newFont = NSFont(name: CPFontManager.currentFont.familyName!, size: getFontSize(toFitRect: frame, fromGlyphRectWhereFontSizeEqualsOne: rect) * 2)!
        let newRect = CTFontGetBoundingRectsForGlyphs(newFont, .default, glyphs, characterFrames, len)
        let points = [CGPoint(x: (frame.size.width * 0.5) - newRect.width * 0.5 - newRect.origin.x, y: (frame.size.height * 0.5) - (newRect.height * 0.5) - newRect.origin.y)]
        //  let points = [CGPoint(x: 0, y: (frame.size.height * 0.5) - (newRect.height * 0.5) - newRect.origin.y)]
        let rawPointer = UnsafeRawPointer(points)
        let pointer = rawPointer.assumingMemoryBound(to: CGPoint.self)
        
        ctx.saveGState()
        CTFontDrawGlyphs(newFont, glyphs, pointer, len, ctx)
        ctx.restoreGState()
    }
    
    private func getFontSize(toFitRect rect: CGRect, fromGlyphRectWhereFontSizeEqualsOne glyphRect: CGRect) -> CGFloat {
        
        let maxWidth = rect.width / (glyphRect.width + glyphRect.origin.x)
        let maxHeight = rect.height / (glyphRect.height + glyphRect.origin.y)
        // let maxWidth = rect.width / glyphRect.width
        // let maxHeight = rect.height / glyphRect.height - abs(glyphRect.origin.y)
        return maxWidth < maxHeight ? maxWidth : maxHeight
    }
}
