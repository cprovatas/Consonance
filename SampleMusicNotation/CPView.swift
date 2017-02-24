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
        wantsLayer = true
        if layer == nil {
            layer = CALayer()
        }                                
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if backgroundColor == nil { return }
        backgroundColor!.set()
        NSRectFill(bounds)
    }
}
