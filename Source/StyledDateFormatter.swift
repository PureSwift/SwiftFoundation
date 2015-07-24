//
//  StyledDateFormatter.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Formats a date according to a set style.
public struct StyledDateFormatter: Formatter {
    
    // MARK: - Properties
    
    public var dateStyle: DateFormatterStyle {
        
        get { return CFDateFormatterGetDateStyle(self.internalFormatter).toDateFormatterStyle() }
        set { self.internalFormatter = CFDateFormatterRef.withStyle(self.dateStyle, timeStyle: self.timeStyle) }
    }
    
    public var timeStyle: DateFormatterStyle {
        
        get { return CFDateFormatterGetTimeStyle(self.internalFormatter).toDateFormatterStyle() }
        set { self.internalFormatter = CFDateFormatterRef.withStyle(self.dateStyle, timeStyle: self.timeStyle) }
    }
    
    // MARK: - Private Properties
    
    private var internalFormatter: CFDateFormatterRef
    
    // MARK: - Initialization
    
    public init(dateStyle: DateFormatterStyle = .NoStyle, timeStyle: DateFormatterStyle = .NoStyle) {
        
        self.internalFormatter = CFDateFormatterRef.withStyle(dateStyle, timeStyle: timeStyle)
    }
    
    // MARK: - Format
    
    public func stringForValue(value: Date) -> String {
        
        return self.internalFormatter.stringFromDate(value)
    }
    
    public func valueWithString(string: String) -> Date? {
        
        return self.internalFormatter.dateFromString(string)
    }
}

private final class DateFormatterWrapper {
    
    var formatter: CFDateFormatterRef
    
    init(formatter: CFDateFormatterRef) { self.formatter = formatter }
}

/// Date and time format style
public enum DateFormatterStyle {
    
    case NoStyle
    case ShortStyle
    case MediumStyle
    case LongStyle
    case FullStyle
}