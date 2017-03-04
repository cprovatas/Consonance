//
//  CPNotationRenderLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 2/22/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

class CPGlyphLayer : CALayer {
    
    public var glyphAsString : String?
    
    public var anchorAttributes : CPGlyphAnchorAttributes?
    public var glyphName : String?
    public var fontSize : CGFloat?
    public var glyphRect : CGRect?
    
    convenience init(glyphAsString: String) {
        self.init()
        self.glyphAsString = glyphAsString
        shouldRasterize = true
        contentsScale = CPGlobals.contentScaleFactor
        rasterizationScale = CPGlobals.contentScaleFactor
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
      //  let rect = CTFontGetOpticalBoundsForGlyphs(CPFontManager.currentFont as CTFont, glyphs, characterFrames, len, CFOptionFlags.allZeros)
        let rect = CTFontGetBoundingBox(CPFontManager.currentFont as CTFont)
        //let rect = CTFontGetBoundingRectsForGlyphs(CPFontManager.currentFont as CTFont, .default, glyphs, characterFrames, len)
       // Swift.print(rect.origin)
        
        setGlyphs(glyphs.pointee)
        
        let newFont = NSFont(name: CPFontManager.currentFont.familyName!, size: getFontSize(toFitRect: frame, fromGlyphRectWhereFontSizeEqualsOne: rect))!
        self.fontSize = newFont.pointSize
        let newRect = CTFontGetBoundingRectsForGlyphs(newFont, .default, glyphs, characterFrames, len)
       // Swift.print(newRect)
        //#MARK - convert to our coordinate space
       // Swift.print(newRect)
        let points = [CGPoint(x: (frame.size.width * 0.5) - newRect.width * 0.5 - newRect.origin.x, y: (frame.size.height * 0.5) - (newRect.height * 0.5) - newRect.origin.y)]
        self.glyphRect = CGRect(origin: points.last!, size: newRect.size)
        
      //  let points = [CGPoint.zero]
        //  let points = [CGPoint(x: 0, y: (frame.size.height * 0.5) - (newRect.height * 0.5) - newRect.origin.y)]
        let rawPointer = UnsafeRawPointer(points)
        let pointer = rawPointer.assumingMemoryBound(to: CGPoint.self)
       
        ctx.saveGState()
        CTFontDrawGlyphs(newFont, glyphs, pointer, len, ctx)
        ctx.restoreGState()        
    }
    
    private func setGlyphs(_ glyph: CGGlyph) {
        let customFont = CGFont("Bravura" as CFString)!
        
        let name = customFont.name(for: glyph)!
        self.glyphName = CPGlyphJSONSerialization.getFormattedGlyphName(forUnicodeGlyphName: name)
        self.anchorAttributes = CPGlyphJSONSerialization.getGlyphAnchorAttributes(fromFormattedGlyphName: self.glyphName!)
    }
    
    private func getFontSize(toFitRect rect: CGRect, fromGlyphRectWhereFontSizeEqualsOne glyphRect: CGRect) -> CGFloat {
        
        let maxWidth = rect.width / (glyphRect.width / 4)
        let maxHeight = rect.height / (glyphRect.height / 4)
        // let maxWidth = rect.width / glyphRect.width
        // let maxHeight = rect.height / glyphRect.height - abs(glyphRect.origin.y)
        return maxWidth < maxHeight ? maxWidth : maxHeight
    }
}
