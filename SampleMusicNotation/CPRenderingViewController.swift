//
//  CPRenderingViewController.swift
//  Consonance
//
//  Created by Charlton Provatas on 1/22/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Cocoa

class CPRenderingViewController: CPViewController {
        
    @IBOutlet weak var renderingView: CPView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let f = renderingView.frame
        
        let path = Bundle.main.path(forResource: "sample", ofType: "xml")!
        let url = URL(fileURLWithPath: path)
        logExecutionTime {
            CPMusicXMLParser.renderMusic(onRenderingLayer: self.renderingView.layer!, fromURL: url)
        }        
    }
    
}

