//
//  StyledDateFormatter.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Formats a date according to a date and time style.
public struct StyledDateFormatter: Formatter {
    
    // MARK: - Properties
    
    public var locale: Locale? { didSet { didMutate() } }
    
    public var dateStyle: DateFormatterStyle { didSet { didMutate() } }
    
    public var timeStyle: DateFormatterStyle { didSet { didMutate() } }
    
    // MARK: - Private Properties
    
    private var internalFormatter: InternalDateFormatter
    
    // MARK: - Initialization
    
    public init(dateStyle: DateFormatterStyle = .NoStyle, timeStyle: DateFormatterStyle = .NoStyle, locale: Locale? = nil) {
        
        let formatter = CFDateFormatterRef.withStyle(dateStyle, timeStyle: timeStyle, locale: locale)
        
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
        self.locale = locale
        self.internalFormatter = InternalDateFormatter(value: formatter)
    }
    
    // MARK: - Format
    
    public func stringFromValue(value: Date) -> String {
        
        return self.internalFormatter.stringFromDate(value)
    }
    
    public func valueFromString(string: String) -> Date? {
        
        return self.internalFormatter.dateFromString(string)
    }
        
    // MARK: - Private Methods
        
    private mutating func didMutate() {
        
        self = StyledDateFormatter(dateStyle: self.dateStyle, timeStyle: self.timeStyle, locale: self.locale)
    }
}

/// Date and time format style
public enum DateFormatterStyle {
    
    case NoStyle
    case ShortStyle
    case MediumStyle
    case LongStyle
    case FullStyle
}

