//
//  Type Declarations.swift
//  SampleMusicNotation
//
//  Created by Charlton Provatas on 1/22/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import AppKit

typealias UIViewController = NSViewController
typealias UIView = NSView

//perhaps we can include a specific 'pitch' type. ie enums to determine notes or something

enum CPDuration {
    case sixteenth
    case eigth
    case quarter
    case half
    case whole
}

