//
//  Globals.swift
//  SampleMusicNotation
//
//  Created by Charlton Provatas on 1/22/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation

public struct CPGlobals {
    
    public static var contentScaleFactor : CGFloat = 1.0
    
}

// Global Functions:
func logExecutionTime(_ block: () -> Void) {
    let startTime = CFAbsoluteTimeGetCurrent()
    block()
    CPDebugger.show("Method Execution Time: ", CFAbsoluteTimeGetCurrent() - startTime)
}
