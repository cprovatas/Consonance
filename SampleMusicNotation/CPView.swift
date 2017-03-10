//
//  CPView.swift
//  SampleMusicNotation
//
//  Created by Charlton Provatas on 1/24/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import AppKit
import Cocoa

@IBDesignable
class CPView : UIView {
    
    @IBInspectable public var backgroundColor : NSColor?
    @IBInspectable public var cornerRadius : CGFloat = 0  {
        didSet {
            layer?.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var borderWidth : CGFloat = 0 {
        didSet {
            layer?.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor : NSColor? {
        didSet {
            layer?.borderColor = borderColor!.cgColor
        }
    }
    
    @IBInspectable public var alpha : CGFloat = 1 {
        didSet {
            alphaValue = alpha
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if layer == nil {
            layer = TEstLayer()
            layerContentsRedrawPolicy = .never
            layer!.contentsScale = CPGlobals.contentScaleFactor
            layer!.masksToBounds = false
            layer!.drawsAsynchronously = true
        }                                
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if backgroundColor == nil { return }
        backgroundColor!.set()
        NSRectFill(bounds)
    }
}

class TEstLayer : CALayer {
    
   
    override func render(in ctx: CGContext) {
      //  super.render(in: ctx)
    }
    
    override func resize(withOldSuperlayerSize size: CGSize) {
        
    }
    
    override func draw(in ctx: CGContext) {
    }
    override func resizeSublayers(withOldSize size: CGSize) {
      //  super.resizeSublayers(withOldSize: size)
    }
    
    override func setNeedsLayout() {
        
    }
    
    override func setNeedsDisplay() {
        
    }
    
    override func setNeedsDisplayIn(_ r: CGRect) {
        
    }
    
    override func layoutSublayers() {
        
    }
    
    override func layoutIfNeeded() {
        
    }
    
    override func displayIfNeeded() {
        
    }
    
    override func display() {
        
    }
    
    override func needsLayout() -> Bool {
        return false
    }
    
    override func needsDisplay() -> Bool {
        return false
    }
    
    override var needsDisplayOnBoundsChange: Bool{
        get {
            return false
        }set { }
    }

}

