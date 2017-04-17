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
}
