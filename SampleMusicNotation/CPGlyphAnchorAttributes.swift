import Foundation

public struct CPGlyphAnchorAttributes {
    
    public init() {
        self.init()
    }
    // The exact position at which the bottom right-hand (south-east) corner
    // of an angled upward-pointing stem connecting the right-hand side of a
    // notehead to a vertical stem to its left should start, relative to the glyph origin,
    // expressed as Cartesian coordinates in staff spaces.
    
    public var splitStemUpSE : CGPoint?
    
    /* The exact position at which the bottom left-hand 
     (south-west) corner of an angled upward-pointing stem
     connecting the left-hand side of a notehead to a vertical 
     stem to its right should start, relative to the glyph origin, 
     expressed as Cartesian coordinates in staff spaces.
     */
    public var splitStemUpSW : CGPoint?
    
//    The exact position at which the top right-hand (north-east) corner
//    of an angled downward-pointing stem connecting the right-hand side
//    of a notehead to a vertical stem to its left should start, relative
//    to the glyph origin, expressed as Cartesian coordinates in staff spaces.
    public var splitStemDownNE : CGPoint?
    
//    The exact position at which the top left-hand (north-west) corner of an
//    angled downward-pointing stem connecting the left-hand side of a notehead
//    to a vertical stem to its right should start, relative to the glyph origin,
//    expressed as Cartesian coordinates in staff spaces.
    public var splitStemDownNW : CGPoint?
    
//    The exact position at which the bottom right-hand (south-east) corner of an
//    upward-pointing stem rectangle should start, relative to the glyph origin,
//    expressed as Cartesian coordinates in staff spaces.
      public var stemUpSE : CGPoint?
    
//    The exact position at which the top left-hand (north-west) corner of a downward-pointing
//    stem rectangle should start, relative to the glyph origin, expressed as Cartesian
//    coordinates in staff spaces.
    public var stemDownNW : CGPoint?
//    
//    The amount by which an up-stem should be lengthened from its nominal unmodified length
//    in order to ensure a good connection with a flag, in spaces.
    public var stemUpNW : CGPoint?
    
//    The amount by which a down-stem should be lengthened from its nominal unmodified length
//    in order to ensure a good connection with a flag, in spaces.
    public var stemDownSW : CGPoint?
    
//    The width in staff spaces of a given glyph that should be used for e.g. positioning leger lines
//    correctly.
    public var nominalWidth : CGPoint?
    
//    The position in staff spaces that should be used to position numerals relative to clefs with ligated
//    numbers where those numbers hang from the bottom of the clef, corresponding horizontally to the center
//    of the numeral’s bounding box.
    public var numeralTop : CGPoint?
    
//    The position in staff spaces that should be used to position numerals relative to clefs with ligatured
//    numbers where those numbers sit on the baseline or at the north-east corner of the G clef, corresponding
//    horizontally to the center of the numeral’s bounding box.
    public var numeralBottom : CGPoint?
    
//    The Cartesian coordinates in staff spaces of the bottom left corner of a nominal rectangle that intersects the
//    top right corner of the glyph’s bounding box. This rectangle, together with those in the other four corners of
//    the glyph’s bounding box, can be cut out to produce a more detailed bounding box (of abutting rectangles),
//    useful for kerning or interlocking symbols such as accidentals.
    public var cutOutNE : CGPoint?
    
//    The Cartesian coordinates in staff spaces of the top left corner of a nominal rectangle that intersects the
//    bottom right corner of the glyph’s bounding box.
    public var cutOutSE : CGPoint?
    
//    The Cartesian coordinates in staff spaces of the top right corner of a nominal rectangle that intersects the bottom
//    left corner of the glyph’s bounding box.
    public var cutOutSW : CGPoint?
    
//    The Cartesian coordinates in staff spaces of the bottom right corner of a nominal rectangle that intersects the top
//    left corner of the glyph’s bounding box.
    public var cutOutNW : CGPoint?
    
//    The Cartesian coordinates in staff spaces of the position at which the glyph graceNoteSlashStemUp should be positioned
//    relative to the stem-up flag of an unbeamed grace note; alternatively, the bottom left corner of a diagonal line drawn
//    instead of using the above glyph.
    public var graceNoteSlashSW : CGPoint?
    
//    The Cartesian coordinates in staff spaces of the top right corner of a diagonal line drawn instead of using the glyph
//    graceNoteSlashStemUp for a stem-up flag of an unbeamed grace note.
    public var graceNoteSlashNE : CGPoint?
    
//    The Cartesian coordinates in staff spaces of the position at which the glyph graceNoteSlashStemDown should be positioned
//    relative to the stem-down flag of an unbeamed grace note; alternatively, the top left corner of a diagonal line drawn instead
//    of using the above glyph.
    public var graceNoteSlashNW : CGPoint?
    
//    The Cartesian coordinates in staff spaces of the bottom right corner of a diagonal line drawn instead of using the glyph
//    graceNoteSlashStemDown for a stem-down flag of an unbeamed grace note.
    public var graceNoteSlashSE : CGPoint?
    
//    The Cartesian coordinates in staff spaces of the horizontal position at which a glyph repeats, i.e. the position at
//    which the same glyph or another of the same group should be positioned to ensure correct tessellation. This is used
//    for e.g. multi-segment lines and the component glyphs that make up trills and mordents.
    public var repeatOffset : CGPoint?
    
//    The Cartesian coordinates in staff spaces of the left-hand edge of a notehead with a non-zero left-hand side bearing
//    (e.g. a double whole, or breve, notehead with two vertical lines at each side), to assist in the correct horizontal
//    alignment of these noteheads with other noteheads with zero-width left-side bearings.
    public var noteheadOrigin : CGPoint?
    
//    The Cartesian coordinates in staff spaces of the optical center of the glyph, to assist in the correct horizontal alignment
//    of the glyph relative to a notehead or stem. Currently recommended for use with glyphs in the Dynamics range.
    public var opticalCenter : CGPoint?
}
