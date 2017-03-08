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
        let rectSize = CGSize(width: f.size.width / 3, height: f.size.height / 3)
        let rect = CGRect(x: f.midX - rectSize.width * 0.5, y: f.midY - rectSize.height * 0.5, width: rectSize.width, height: rectSize.height)
        let measure = CPMeasureLayer(frame: rect)
        renderingView.layer!.addSublayer(measure)
        
        let path = Bundle.main.path(forResource: "sample", ofType: "xml")!
        let url = URL(fileURLWithPath: path)
        CPMusicXMLParser.renderMusic(onRenderingLayer: renderingView.layer!, fromURL: url)
    }
    
}

