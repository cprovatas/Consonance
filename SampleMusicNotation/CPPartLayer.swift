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
            if oldValue != measures {
                self.sublayers = nil
                layoutMeasures()
            }
        }
    }

    init(id: String, measures: [CPMeasureLayer], frame: CGRect) {
        super.init()
        self.id = id
        self.measures = measures
        self.frame = CGRect(x: frame.width * 0.01, y: frame.height * 0.25, width: frame.width * 0.25, height: frame.height * 0.5)
        layoutMeasures()
    }
    
    private func layoutMeasures() {
        //TODO : provide some sort of layout system for laying out the measures here, need to research default rules... etc
        for measure in measures {
            measure.frame.size.height = self.frame.height
            addSublayer(measure)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
