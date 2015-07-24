//
//  DateFormatter.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Formats a date to and from a string.
public final class DateFormatter: Formatter {
    
    // MARK: - Properties
    
    
    
    // MARK: - Private Properties
    
    /// Internal Date formatter.
    ///
    /// - Note: Not thread safe.
    private var internalFormatter: CFDateFormatter
    
    // MARK: - Format
    
    public func stringForValue(value: Date) -> String {
        
        return self.internalFormatter.stringFromDate(value)
    }
    
    public func valueWithString(string: String) -> Date? {
        
        return self.internalFormatter.dateFromString(string)
    }
    
    // MARK: - Private Methods
    
    private mutating func ensureUnique() {
        if !isUniquelyReferencedNonObjC(&internalFormatter) {
            internalFormatter = internalFormatter.copy()
        }
    }
}