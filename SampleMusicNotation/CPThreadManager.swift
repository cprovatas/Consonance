//
//  CPThreadManager.swift
//  Consonance
//
//  Created by Charlton Provatas on 2/27/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation

class CPThreadManager {
    
    class func execute(_ block: @escaping () -> Void, afterDelay delay: TimeInterval) {
        let dispatchTime = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            block()
        }
    }
}
