//
//  CPMusicXMLParser.swift
//  Consonance
//
//  Created by Charlton Provatas on 3/6/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation
import Cocoa
import SWXMLHash

final class CPMusicXMLParser {
    
    public class func renderMusic(onRenderingLayer layer: CALayer, fromURL url: URL) {
        //TODO: make this safer :)
        let string = try! String(contentsOf: url)
        let parsed = SWXMLHash.parse(string)
        let score = parsed["score-partwise"]
        parse(parts: score["part"], layer: layer)
    }
    
    private class func parse(parts: XMLIndexer, layer: CALayer) {
        
        for part in parts {
            let tempPart = CPPartLayer(id: part.element?.value(ofAttribute: "id") ?? "P1",
                                       measures: parse(measures: part["measure"], layer), frame: layer.frame)
            
            layer.addSublayer(tempPart)
        }        
    }
    
    private class func parse(measures: XMLIndexer, _ layer: CALayer) -> [CPMeasureLayer] {
        var theMeasures : [CPMeasureLayer] = []
        //TODO: other measure formatting stuff :)
        for measure in measures {
            let aMeasure = CPMeasureLayer()
            aMeasure.clef = parse(clef: measure["attributes"]["clef"])
            aMeasure.notes = parse(notes: measure["note"], layer)
            aMeasure.frame.size.width = (measure.element?.value(ofAttribute: "width") ?? "\(layer.frame.width)").cgFloat
            theMeasures.append(aMeasure)
        }
        return theMeasures
    }
    
    //TODO, finish up clef stuff :)
    private class func parse(clef: XMLIndexer) -> CPClefLayer? {
        let aClef = CPClefLayer(CPClefLayerSign(rawValue: clef["sign"].element?.text ?? "g"),
                                clef["line"].element?.text?.int ?? 0)
        return aClef
    }
    
    private class func parse(notes: XMLIndexer, _ layer: CALayer) -> [CPNoteLayer] {
        var notesArr : [CPNoteLayer] = []
        for n in notes {
            let note = CPNoteLayer(pitches: parse(pitches: n["pitch"]),
                                   noteDuration: n["duration"].element?.text?.int ?? 0,
                                   voice: n["voice"].element?.text?.int ?? 0,
                                   type: CPNoteLayerDurationType(rawValue: n["type"].element?.text ?? "quarter"),
                                   stemPosition: CPStemLayerPosition(rawValue: n["position"].element?.text ?? "none"))
            
            //TODO: xPosition
            note.explicitXPosition = (n.element?.value(ofAttribute: "default-x") ?? "").cgFloat
            notesArr.append(note)
        }
        
        return notesArr
    }
    
    private class func parse(pitches: XMLIndexer) -> [CPPitch] {
        var pitchesArr : [CPPitch] = []
        for p in pitches {
            let pitch = CPPitch(step: CPPitchLetter(rawValue: p["step"].element?.text ?? "a"),
                                octave: (p["octave"].element?.text ?? "4").int)
            pitchesArr.append(pitch)
        }
        return pitchesArr
    }
    
    
}
