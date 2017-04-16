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
            aMeasure.glyphs = parseMeasureChildren(measure, layer, aMeasure)
            aMeasure.frame.size.width = (measure.element?.value(ofAttribute: "width") ?? "\(layer.frame.width)").cgFloat
            theMeasures.append(aMeasure)
        }
        return theMeasures
    }
    
    private class func parseMeasureChildren(_ measure: XMLIndexer, _ layer: CALayer, _ measureLayer: CPMeasureLayer) -> [CPLayer] {
        var glyphs : [CPLayer] = []
        
        for child in measure.children {
            
            if child.element == nil { continue }
            if child.element!.name.lowercased() == "note" {
                glyphs.append(parse(note: child, layer))
            }else if child.element!.name.lowercased() == "attributes" {
                if child["clef"].element != nil {
                    glyphs.append(parse(clef: child["clef"]))
                }
                
                if child["key"].element != nil {
                    glyphs.append(parse(keySignature: child["key"]))
                }
            }
        }
        
        return glyphs
    }
    
    private class func parse(keySignature: XMLIndexer) -> CPKeySignatureLayer {
        return CPKeySignatureLayer((keySignature["fifths"].element?.text ?? "0").int,
                              mode: CPKeySignatureMode(rawValue: keySignature["mode"].element?.text ?? "major"))
    }
    
    private class func parse(clef: XMLIndexer) -> CPClefLayer {
        let aClef = CPClefLayer(CPClefLayerSign(rawValue: clef["sign"].element?.text ?? "g"),
                                clef["line"].element?.text?.int ?? 0,
                                CPClefLayerSignOctaveOffsetDirection(rawValue: clef["clef-octave-change"].element?.text?.int ?? 0)) //initalizer will fail if 0 is passed
        return aClef
    }
    
    private class func parse(note: XMLIndexer, _ layer: CALayer) -> CPNoteLayer {
        
        let aNote = CPNoteLayer(pitches: parse(pitches: note["pitch"]),
                               noteDuration: note["duration"].element?.text?.int ?? 0,
                               voice: note["voice"].element?.text?.int ?? 0,
                               type: CPNoteLayerDurationType(rawValue: note["type"].element?.text ?? "quarter"),
                               stemPosition: CPStemLayerPosition(rawValue: note["position"].element?.text ?? "none"))
        
        
        aNote.explicitXPosition = (note.element?.value(ofAttribute: "default-x") ?? "").cgFloat
        
        return aNote
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





extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
