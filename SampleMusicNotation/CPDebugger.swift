//
//  CPDebugger.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/22/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation

final class CPDebugger {
    
    public static let enableBorders : Bool = true
    
    public static let debugEnabled : Bool = true
    
    public class func show(_ msg: Any) {
        if debugEnabled {
            Swift.print(msg)
        }
    }
    
}
