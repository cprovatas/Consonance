//
//  ViewController.swift
//  SampleMusicNotation
//
//  Created by Charlton Provatas on 1/22/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Cocoa

class CPRenderingViewController: CPViewController {
        
    @IBOutlet weak var renderingView: CPView!
    
    override func viewDidLayout() {
        super.viewDidLayout()
        let f = renderingView.frame
        
        
        let rect = CGRect(x: f.midX, y: f.midY, width: f.size.width / 2, height: f.size.height / 2)
       // let rect = renderingView.bounds
        let measure = CPNotationRender.drawMeasure(inRect: rect)
        let noteLayer = CPNotationRenderLayer(glyphAsString: "")
        noteLayer.frame = measure.frame
        
        
        renderingView.layer!.addSublayer(measure)
        renderingView.layer!.addSublayer(noteLayer)
        
    }
}

