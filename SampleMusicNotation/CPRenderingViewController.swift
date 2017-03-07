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
        renderNote(inMeasure: measure, atXPosition: 50)
        renderNote(inMeasure: measure, atXPosition: -50)
        renderNote(inMeasure: measure, atXPosition: -100)
        renderNote(inMeasure: measure, atXPosition: 100)
                
        renderNote(inMeasure: measure, atXPosition: 250)
    }
    
    private func renderNote(inMeasure measure: CALayer, atXPosition x: CGFloat) {
        let noteLayer = CPGlyphLayer(glyphAsString: "")
        noteLayer.frame = CGRect(x: x, y: 0 - ((measure.frame.size.height / 4) * 1.5), width: measure.frame.size.width, height: measure.frame.height)
        
        
        measure.addSublayer(noteLayer)
        
        let flag = CPGlyphLayer(glyphAsString: "")
        
        let point = CGPoint(x: noteLayer.glyphRect!.origin.x + ((noteLayer.anchorAttributes!.stemUpSE!.x * noteLayer.fontSize!) / 4), y: (noteLayer.glyphRect!.origin.y + (noteLayer.anchorAttributes!.stemUpSE!.y * noteLayer.fontSize!) / 4))
        
        let stem = CPStemLayer(fromPoint: point, toYPosition: point.y + (measure.frame.height / 4) * 3.25)
        noteLayer.addSublayer(stem)
        
        let fr = measure.bounds
        flag.frame = CGRect(x: noteLayer.glyphRect!.width + x, y: 0, width: fr.width, height: fr.height - fr.height / 6)
        
        measure.addSublayer(flag)
        
        flag.frame.origin.x -= abs(flag.glyphRect!.maxX - noteLayer.glyphRect!.maxX)
        flag.frame.origin.x -= 2.5
        
        flag.frame.origin.y = (noteLayer.convert(stem.maxYPoint, to: measure).y - (flag.frame.height - ((flag.frame.height - flag.glyphRect!.height) * 0.5)))
    }
}

