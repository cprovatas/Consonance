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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let f = renderingView.frame
        
        let rect = CGRect(x: f.midX, y: f.midY, width: f.size.width / 4, height: f.size.height / 4)
        let measure = CPNotationRender.drawMeasure(inRect: rect)
        
        let newRect = CGRect(x: rect.maxX, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
        let newLayer = CPNotationRender.drawMeasure(inRect: newRect)
        
        let noteRect = CGRect(x: 15, y: measure.boundingNoteSpacingHeight * 0.5, width: measure.boundingNoteSpacingHeight, height: measure.boundingNoteSpacingHeight)
        let head = CPNotationRender.drawFilledOval(inRect: noteRect)
        
        let stem = CPNotationRender.drawStem(fromPoint: CGPoint(x: head.endPoint.x, y: head.endPoint.y), toY: head.endPoint.y + measure.fullNoteSectionHeight * 3)
        
        renderingView.layer!.addSublayer(measure)
        measure.addSublayer(stem)
        measure.addSublayer(head)
        
        
        renderingView.layer!.addSublayer(newLayer)
        
        
    }
}

