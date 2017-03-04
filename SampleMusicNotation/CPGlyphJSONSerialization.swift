import Foundation

open class CPGlyphJSONSerialization {
    //TODO: we probably want to have this json object present in memory as a singleton, so we don't read from a file everytime
    //TODO: we obviously should make this robust
    typealias GlyphAnchorAttributes = Dictionary<String, [CGFloat]>
        
    public class func getFormattedGlyphName(forUnicodeGlyphName name: CFString) -> String {
        let newName = (name as String).replacingOccurrences(of: "uni", with: "U+")
        let json = getJSON(fromJSONFileWithName: "glyphnames") as! Dictionary<String, Any>
        
        for (key, value) in json {
            let codepoints = value as! Dictionary<String, String>
            if codepoints["codepoint"] == newName || (codepoints["alternateCodepoint"] != nil && codepoints["alternateCodepoint"] == newName) {
                return key
            }
        }
        
        return ""
    }
    
    public class func getGlyphAnchorAttributes(fromFormattedGlyphName name: String) -> CPGlyphAnchorAttributes? {
        let json = getJSON(fromJSONFileWithName: "bravura_metadata") as! Dictionary<String, Any>
        let anchorAttributes = json["glyphsWithAnchors"] as! Dictionary<String, Any>
        if let properties = anchorAttributes[name] as? GlyphAnchorAttributes {
            return serializeAnchorAttributes(properties)
        }
        return nil
    }
    
    private class func serializeAnchorAttributes(_ properties: GlyphAnchorAttributes) -> CPGlyphAnchorAttributes {
        
        
        var anchorAttributes = CPGlyphAnchorAttributes()        
        anchorAttributes.splitStemUpSE = serialize(point: properties["splitStemUpSE"])        
        anchorAttributes.splitStemUpSW = serialize(point: properties["splitStemUpSW"])
        anchorAttributes.splitStemDownNE = serialize(point: properties["splitStemDownNE"])
        anchorAttributes.splitStemDownNW = serialize(point: properties["splitStemDownNW"])
        
        anchorAttributes.stemUpSE = serialize(point: properties["stemUpSE"])
        anchorAttributes.stemDownNW = serialize(point: properties["stemDownNW"])
        anchorAttributes.stemUpNW = serialize(point: properties["stemUpNW"])
        anchorAttributes.stemDownSW = serialize(point: properties["stemDownSW"])
        anchorAttributes.nominalWidth = serialize(point: properties["nominalWidth"])
        anchorAttributes.numeralTop = serialize(point: properties["numeralTop"])
        anchorAttributes.numeralBottom = serialize(point: properties["numeralBottom"])
        anchorAttributes.cutOutNE = serialize(point: properties["cutOutNE"])
        anchorAttributes.cutOutSE = serialize(point: properties["cutOutSE"])
        anchorAttributes.cutOutSW = serialize(point: properties["cutOutSW"])
        anchorAttributes.cutOutNW = serialize(point: properties["cutOutNW"])
        anchorAttributes.graceNoteSlashSW = serialize(point: properties["graceNoteSlashSW"])
        anchorAttributes.graceNoteSlashNE = serialize(point: properties["graceNoteSlashNE"])
        anchorAttributes.graceNoteSlashNW = serialize(point: properties["graceNoteSlashNW"])
        anchorAttributes.graceNoteSlashSE = serialize(point: properties["graceNoteSlashSE"])
        anchorAttributes.repeatOffset = serialize(point: properties["repeatOffset"])
        anchorAttributes.noteheadOrigin = serialize(point: properties["noteheadOrigin"])
        anchorAttributes.opticalCenter = serialize(point: properties["opticalCenter"])
        
        
        return anchorAttributes
    }
    
    private class func serialize(point: [CGFloat]?) -> CGPoint? {
        if point == nil || point!.count < 2 { return nil }
        return CGPoint(x: point![0], y: point![1])
    }
    
    private class func getJSON(fromJSONFileWithName name: String) -> Any? {
        //obviously, this is super unsafe
        let path = Bundle.main.path(forResource: name, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        return json
    }
    
    
}
