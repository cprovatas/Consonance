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
        
        let rect = CGRect(x: f.midX, y: f.midY, width: f.size.width / 4, height: f.size.height / 4)
        let measure = CPMeasureLayer(frame: rect)
        let noteLayer = CPGlyphLayer(glyphAsString: "")
        noteLayer.frame = CGRect(x: measure.frame.origin.x, y: measure.frame.origin.y - ((measure.frame.size.height / 4) * 1.5), width: measure.frame.size.width, height: measure.frame.height)
        
        renderingView.layer!.addSublayer(measure)
        renderingView.layer!.addSublayer(noteLayer)
        
        let flag = CPGlyphLayer(glyphAsString: "")
            
        let point = CGPoint(x: noteLayer.glyphRect!.origin.x + ((noteLayer.anchorAttributes!.stemUpSE!.x * noteLayer.fontSize!) / 4), y: (noteLayer.glyphRect!.origin.y + (noteLayer.anchorAttributes!.stemUpSE!.y * noteLayer.fontSize!) / 4))
       
        
        let stem = CPStemLayer(fromPoint: point, toYPosition: point.y + (measure.frame.height / 4) * 3)
        noteLayer.addSublayer(stem)
        
        let fr = measure.bounds
        flag.frame = CGRect(x: noteLayer.glyphRect!.width, y: 0, width: fr.width, height: fr.height - fr.height / 6)
       
        measure.addSublayer(flag)
      
        flag.frame.origin.x -= abs(flag.glyphRect!.maxX - noteLayer.glyphRect!.maxX)
        flag.frame.origin.x -= 2.5
        
        flag.frame.origin.y = (noteLayer.convert(stem.maxYPoint, to: measure).y - (flag.frame.height - ((flag.frame.height - flag.glyphRect!.height) * 0.5)))
    }
}

