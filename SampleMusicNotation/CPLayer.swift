//
//  CPLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/5/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa

class CPLayer : CAShapeLayer {
    
    override init() {
        super.init()
        shouldRasterize = true
        rasterizationScale = CPGlobals.contentScaleFactor
        contentsScale = CPGlobals.contentScaleFactor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
