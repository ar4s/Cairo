//
//  Pattern.swift
//  Cairo
//
//  Created by Alsey Coleman Miller on 1/31/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import CCairo

/// Represents a source when drawing onto a surface. 
///
/// There are different subtypes of patterns, for different types of sources.
public final class Pattern {
    
    // MARK: - Internal Properties
    
    internal var internalPointer: OpaquePointer
    
    // MARK: - Initialization
    
    deinit {
        
        cairo_pattern_destroy(internalPointer)
    }
    
    internal init(_ internalPointer: OpaquePointer) {
        
        self.internalPointer = internalPointer
    }
    
    public init(surface: Surface) {
        
        self.internalPointer = cairo_pattern_create_for_surface(surface.internalPointer)
    }
    
    public init(linear: ((Double, Double), (Double, Double))) {
        
        self.internalPointer = cairo_pattern_create_linear(linear.0.0, linear.0.1, linear.1.0, linear.1.1)
    }
    
    public init(radial: (start: (center: (x: Double, y: Double), radius: Double), end: (center: (x: Double, y: Double), radius: Double))) {
        
        self.internalPointer = cairo_pattern_create_radial(radial.start.center.x, radial.start.center.y, radial.start.radius, radial.end.center.x, radial.end.center.y, radial.end.radius)
    }
    
    public static var mesh: Pattern {
        
        let internalPointer = cairo_pattern_create_mesh()
        
        return self.init(internalPointer)
    }
    
    // MARK: - Accessors
    
    public var type: PatternType {
        
        let internalPattern = cairo_pattern_get_type(internalPointer)
        
        let pattern = PatternType(rawValue: internalPattern.rawValue)!
        
        return pattern
    }
    
    // MARK: - Methods
    
    /// Adds an opaque color stop to a gradient pattern.
    public func addColorStop(offset: Double, red: Double, green: Double, blue: Double) {
        
        cairo_pattern_add_color_stop_rgb(internalPointer, offset, red, green, blue)
    }
    
    /// Adds an opaque color stop to a gradient pattern.
    public func addColorStop(offset: Double, red: Double, green: Double, blue: Double, alpha: Double) {
        
        cairo_pattern_add_color_stop_rgba(internalPointer, offset, red, green, blue, alpha)
    }
}


// MARK: - Supporting Types

/// Subtypes of `Pattern`
public enum PatternType: UInt32 {
    
    case Solid, Surface, Linear, Radial, Mesh, RasterSource
}

