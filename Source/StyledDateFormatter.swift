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
    
    public var locale: Locale? { didSet { didMutate() } }
    
    public var dateStyle: DateFormatterStyle { didSet { didMutate() } }
    
    public var timeStyle: DateFormatterStyle { didSet { didMutate() } }
    
    // MARK: - Private Properties
    
    private var internalFormatter: CFDateFormatterRef
    
    private let internalQueue = dispatch_queue_create("StyledDateFormatter Thread Safety Internal Queue", nil)
    
    // MARK: - Initialization
    
    public init(dateStyle: DateFormatterStyle = .NoStyle, timeStyle: DateFormatterStyle = .NoStyle, locale: Locale? = nil) {
        
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
        self.locale = locale
        self.internalFormatter = CFDateFormatterRef.withStyle(dateStyle, timeStyle: timeStyle, locale: locale)
    }
    
    // MARK: - Format
    
    public func stringForValue(value: Date) -> String {
        
        var stringValue: String!
        
        dispatch_sync(self.internalQueue) { () -> Void in
            
            stringValue = self.internalFormatter.stringFromDate(value)
        }
        
        return stringValue
    }
    
    public func valueWithString(string: String) -> Date? {
        
        var date: Date?
        
        dispatch_sync(self.internalQueue) { () -> Void in
            
            date = self.internalFormatter.dateFromString(string)
        }
        
        return date
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

