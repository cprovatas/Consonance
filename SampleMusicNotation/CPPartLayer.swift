//
//  CPPartLayer.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/6/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa


class CPPartLayer : CPLayer {
    
    public var id : String = "P1"
    public var measures : [CPMeasureLayer] = [] {
        didSet {
            self.sublayers = nil
        }
    }
    
    init(id: String, measure: [CPMeasureLayer]) {
        super.init()
        self.id = id
        self.measures = measure
    }
    
    private func layoutMeasures() {
        //TODO : provide some sort of layout system for laying out the measures here, need to research default rules... etc
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
