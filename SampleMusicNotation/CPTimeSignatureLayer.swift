//
//  CPTimeSignatureLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 4/16/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

final class CPTimeSignatureLayer : CPLayer, CPGlyphRepresentable {
    
    public var numberOfBeats: Int?
    public var beatType: CPNoteLayerDurationType?
    
    //TODO: common & cut-time glyphs
    public lazy var glyphRect: CGRect? = CGRect()
    
    init(numberOfBeats: Int, beatType: CPNoteLayerDurationType) {
        super.init()
        self.numberOfBeats = numberOfBeats
        self.beatType = beatType
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperlayer() {
        super.didMoveToSuperlayer()
        layout()
    }
    
    private func layout() {
        // have a container CALayer for denominator and numerator and then move it to the center after all the glyphs have been added
        // make each side it's own side
        let numeratorLayer = CPTimeSignatureLayer.createDigitLayer(forInt: numberOfBeats!, superlayerFrame: frame)
        let denominatorDigits = beatType!.rawValue.digitArray
        
       // glyphNum.frame = glyphRect!
        let denominator = CPTimeSignatureNumberLayer(number: beatType!.rawValue)
        let rect = CGRect(x: 0, y: -(frame.height * 0.25), width: 75, height: frame.height)
        denominator.frame = rect
        numeratorLayer.frame = CGRect(x: 0, y: frame.height * 0.25, width: numeratorLayer.frame.width, height: frame.height)
        //addSublayer(numeratorLayer)
        addSublayer(denominator)
    }
    
    private class func createDigitLayer(forInt int: Int, superlayerFrame frame: CGRect) -> CPLayer {
        
        let containerLayer : CPLayer = CPLayer()
        let numeratorDigits = int.digitArray
        var xPos : CGFloat = 0
        for digit in numeratorDigits {
            let glyphNum = CPTimeSignatureNumberLayer(number: digit)
            glyphNum.frame = CGRect(x: xPos, y: 0, width: 100, height: frame.height)
            containerLayer.addSublayer(glyphNum)
            glyphNum.frame.size.width = glyphNum.glyphRect!.width
            xPos += glyphNum.frame.width            
        }
        containerLayer.frame.size.width = CGFloat(numeratorDigits.last ?? 0)
        return containerLayer
    }
}
