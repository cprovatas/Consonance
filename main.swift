//
//  main.swift
//  Consonance
//
//  Created by Charlton Provatas on 4/20/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa


NSApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafePointer<Int8>.self,
            capacity: Int(CommandLine.argc))
)
©˙
