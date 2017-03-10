//
//  CPNotationRenderLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 2/22/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

class CPGlyphLayer : CPLayer {
    
    public var glyphAsString : String? {
        didSet {
            setUpAttributes()
        }
    }
    
    public var anchorAttributes : CPGlyphAnchorAttributes?
    public var glyphName : String?
    public var fontSize : CGFloat?
    public var glyphRect : CGRect?
        
    private var newFont : NSFont!
    private var glyphs : UnsafeMutablePointer<CGGlyph>!
    private var pointer : UnsafePointer<CGPoint>!
    private var len : Int!
    
    override var frame: CGRect {
        didSet {
            setUpAttributes()
            setNeedsDisplay()
        }
    }
    
    convenience init(glyphAsString: String) {
        self.init()
        self.glyphAsString = glyphAsString
        setNeedsDisplay()
    }
    
    private func setUpAttributes() {
        len = glyphAsString!.characters.count
        let characters = UnsafeMutablePointer<UniChar>.allocate(capacity: len)
        let characterFrames =  UnsafeMutablePointer<CGRect>.allocate(capacity: 1)
        CFStringGetCharacters(glyphAsString as! CFString, CFRangeMake(0, len), characters)
        glyphs = UnsafeMutablePointer<CGGlyph>.allocate(capacity: len)
        CTFontGetGlyphsForCharacters(CPFontManager.currentFont as CTFont, characters, glyphs, len)
        //  let rect = CTFontGetOpticalBoundsForGlyphs(CPFontManager.currentFont as CTFont, glyphs, characterFrames, len, CFOptionFlags.allZeros)
        let rect = CTFontGetBoundingBox(CPFontManager.currentFont as CTFont)
        //let rect = CTFontGetBoundingRectsForGlyphs(CPFontManager.currentFont as CTFont, .default, glyphs, characterFrames, len)
        
        setGlyphs(glyphs.pointee)
        
        newFont = NSFont(name: CPFontManager.currentFont.familyName!, size: getFontSize(toFitRect: frame, fromGlyphRectWhereFontSizeEqualsOne: rect))!
        self.fontSize = newFont.pointSize
        let newRect = CTFontGetBoundingRectsForGlyphs(newFont, .horizontal, glyphs, characterFrames, len)
        
        //#MARK - convert to our coordinate space
        let points = [CGPoint(x: (frame.size.width * 0.5) - newRect.width * 0.5 - newRect.origin.x, y: (frame.size.height * 0.5) - (newRect.height * 0.5) - newRect.origin.y)]
        self.glyphRect = CGRect(origin: points.first!, size: newRect.size)
        
        //  let points = [CGPoint(x: 0, y: (frame.size.height * 0.5) - (newRect.height * 0.5) - newRect.origin.y)]
        let rawPointer = UnsafeRawPointer(points)
        pointer = rawPointer.assumingMemoryBound(to: CGPoint.self)
    }
    
    override func draw(in ctx: CGContext) {
        
        shouldRasterize = true
        contentsScale = CPGlobals.contentScaleFactor
        rasterizationScale = CPGlobals.contentScaleFactor

        setUpAttributes()
        ctx.saveGState()
        CTFontDrawGlyphs(newFont, glyphs, pointer, len, ctx)
        ctx.restoreGState()        
    }
    
    private func setGlyphs(_ glyph: CGGlyph) {
        guard let fontName = CPFontManager.currentFont.familyName else {
            Swift.print("\(self.self) Error Function: '\(#function)' Line \(#line).  Font Family name not found")
            return
        }
        
        guard let customFont = CGFont(fontName as CFString) else {
            Swift.print("\(self.self) Error Function: '\(#function)' Line \(#line).  Custom font not found")
            return
        }
        
        guard let name = customFont.name(for: glyph) else {
            Swift.print("\(self.self) Error Function: '\(#function)' Line \(#line).  Couldn't get glyph name")
            return
        }
        
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
