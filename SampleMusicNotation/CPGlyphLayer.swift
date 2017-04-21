//
//  CPNotationRenderLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 2/22/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

protocol CPGlyphRepresentable {
    var glyphRect : CGRect? { get set }
}

class CPGlyphLayer : CPLayer, CPGlyphRepresentable {
    
    public var glyphAsString : String? {
        didSet {
            if oldValue != glyphAsString {
                setUpAttributes()
            }
        }
    }
    
    
    public var anchorAttributes : CPGlyphAnchorAttributes?
    public var glyphName : String?
    public var fontSize : CGFloat?
    public var glyphRect : CGRect?    
    public var fontScalingMode : CPGlyphLayerFontScalingMode! = .centeredVerticallyAndScaled
    private var newFont : NSFont!
    private var glyphs : UnsafeMutablePointer<CGGlyph>!
    private var pointer : UnsafePointer<CGPoint>!
    private var len : Int!
    
    override var frame: CGRect {
        didSet {
            if oldValue != frame {
                setUpAttributes()
                setNeedsDisplay()
            }
        }
    }
     
    convenience init(glyphAsString: String) {
        self.init()
        self.glyphAsString = glyphAsString
        setNeedsDisplay()
    }
    
    private func setUpAttributes() {
        
        if glyphAsString == nil { return }
        
        contentsScale = CPGlobals.contentScaleFactor
        masksToBounds = false
        len = glyphAsString!.characters.count
        let characters = UnsafeMutablePointer<UniChar>.allocate(capacity: len)
        let characterFrames =  UnsafeMutablePointer<CGRect>.allocate(capacity: 1)
        CFStringGetCharacters(glyphAsString as! CFString, CFRangeMake(0, len), characters)
        glyphs = UnsafeMutablePointer<CGGlyph>.allocate(capacity: len)
        CTFontGetGlyphsForCharacters(CPFontManager.currentFont as CTFont, characters, glyphs, len)
        
        let rect = CTFontGetBoundingBox(CPFontManager.currentFont as CTFont)
        
        setGlyphs(glyphs.pointee)        
        newFont = NSFont(name: CPFontManager.currentFont.familyName!, size: getFontSize(toFitRect: frame, fromGlyphRectWhereFontSizeEqualsOne: rect))!
        
        self.fontSize = newFont.pointSize
        let glyphRect = CTFontGetBoundingRectsForGlyphs(newFont, .horizontal, glyphs, characterFrames, len)
        let newRect = fontScalingMode == .naturalVerticalPosition ?
            CTFontGetBoundingBox(newFont as CTFont) :
            glyphRect
        
      
        //#MARK - convert to our coordinate space
        let points = [CGPoint(x: (frame.size.width * 0.5) - glyphRect.width * 0.5, y: (frame.size.height * 0.5) - (newRect.height * 0.5) - newRect.origin.y)]
        self.glyphRect = CGRect(origin: points.first!, size: glyphRect.size)
                
        let rawPointer = UnsafeRawPointer(points)
        pointer = rawPointer.assumingMemoryBound(to: CGPoint.self)
    }
    
    override func draw(in ctx: CGContext) {
        if glyphs == nil { return }
        setUpAttributes()
        ctx.saveGState()
        CTFontDrawGlyphs(newFont, glyphs, pointer, len, ctx)
        ctx.restoreGState()        
    }
    
    
    private func setGlyphs(_ glyph: CGGlyph) {
        guard let fontName = CPFontManager.currentFont.familyName else {
            CPDebugger.show("\(self.self) Error Function: '\(#function)' Line \(#line).  Font Family name not found")
            return
        }
        
        guard let customFont = CGFont(fontName as CFString) else {
            CPDebugger.show("\(self.self) Error Function: '\(#function)' Line \(#line).  Custom font not found")
            return
        }
        
        guard let name = customFont.name(for: glyph) else {
            CPDebugger.show("\(self.self) Error Function: '\(#function)' Line \(#line).  Couldn't get glyph name")
            return
        }
        
        self.glyphName = CPGlyphJSONSerialization.getFormattedGlyphName(forUnicodeGlyphName: name)
        self.anchorAttributes = CPGlyphJSONSerialization.getGlyphAnchorAttributes(fromFormattedGlyphName: self.glyphName!)
    }
    
    private func getFontSize(toFitRect rect: CGRect, fromGlyphRectWhereFontSizeEqualsOne glyphRect: CGRect) -> CGFloat {
        
        //let maxWidth = rect.width / (glyphRect.width / (fontScalingMode == .naturalVerticalPosition ? 1 : 4))
        let maxHeight = rect.height / (glyphRect.height / (fontScalingMode == .naturalVerticalPosition  ? 1 : 4))
     //   return maxWidth < maxHeight ? maxWidth : maxHeight
        return maxHeight
    }
}

enum CPGlyphLayerFontScalingMode {
    case naturalVerticalPosition
    case centeredVerticallyAndScaled
}
