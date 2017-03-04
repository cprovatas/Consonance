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
        
        let rect = CGRect(x: f.midX, y: f.midY, width: f.size.width / 2, height: f.size.height / 2)
       // let rect = renderingView.bounds
        let measure = CPMeasureLayer(frame: rect)
        let noteLayer = CPGlyphLayer(glyphAsString: "")
        noteLayer.frame = CGRect(x: measure.frame.origin.x, y: measure.frame.origin.y - ((measure.frame.size.height / 4) * 1.5), width: measure.frame.size.width, height: measure.frame.height)
                                
        
        renderingView.layer!.addSublayer(measure)
        renderingView.layer!.addSublayer(noteLayer)
        
        let flag = CPGlyphLayer(glyphAsString: "")
        
        
        CPThreadManager.execute({
            
            let point = CGPoint(x: noteLayer.glyphRect!.origin.x + ((noteLayer.anchorAttributes!.stemUpSE!.x * noteLayer.fontSize!) / 4), y: (noteLayer.glyphRect!.origin.y + (noteLayer.anchorAttributes!.stemUpSE!.y * noteLayer.fontSize!) / 4))
           
            
            var stem = CPStemLayer(fromPoint: point, toYPosition: point.y + measure.fullNoteSectionHeight * 3)
            Swift.print(point.y + measure.fullNoteSectionHeight * 2.5)
            noteLayer.addSublayer(stem)
            
            let fr = measure.bounds
            flag.frame = CGRect(x: noteLayer.glyphRect!.width, y: 0, width: fr.width, height: fr.height)
           
            noteLayer.addSublayer(flag)
            
            CPThreadManager.execute({ 
                stem = CPStemLayer(fromPoint: point, toYPosition: (flag.anchorAttributes!.stemUpNW!.y * flag.fontSize!) / 4)
                flag.frame.origin.x -= abs(flag.glyphRect!.maxX - noteLayer.glyphRect!.maxX)
                flag.frame.origin.x -= 2.5
                Swift.print(stem.maxYPoint.y)
                
                //TODO align flag with top point
              //  flag.frame.maxY = ((flag.anchorAttributes!.stemUpNW!.y * flag.fontSize!) / 4)
            }, afterDelay: 1)
            //flag.frame.origin.x -= (flag.frame.origin.x - noteLayer.frame.maxX)
            
            
            
            
        }, afterDelay: 1)
        
    }
}

