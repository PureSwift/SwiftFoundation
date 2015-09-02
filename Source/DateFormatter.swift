//
//  DateFormatter.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Formats a date.
public struct DateFormatter: Formatter {
    
    // MARK: - Properties
    
    public var locale: Locale? {
        
        mutating didSet {
            
            self = DateFormatter(format: format, properties: properties, locale: locale)
        }
    }
    
    public var format: String {
        
        mutating didSet {
            
            if !isUniquelyReferencedNonObjC(&self.internalFormatter) {
                
                // make copy
                self = DateFormatter(format: format, properties: properties, locale: locale)
            }
            
            // set format
            CFDateFormatterSetFormat(self.internalFormatter.value, format)
        }
    }
    
    public var properties: [DateFormatterProperty] {
        
        mutating didSet {
            
            if !isUniquelyReferencedNonObjC(&self.internalFormatter) {
                
                // make copy
                self = DateFormatter(format: format, properties: properties, locale: locale)
            }
            
            // set properties
            self.internalFormatter.value.setProperties(properties)
        }
    }
    
    // MARK: - Private Properties
    
    private var internalFormatter: InternalDateFormatter
    
    private let internalQueue = dispatch_queue_create("DateFormatter Thread Safety Internal Queue", nil)
    
    // MARK: - Initialization
    
    public init(format: String, properties: [DateFormatterProperty] = [], locale: Locale? = nil) {
        
        let formatter = CFDateFormatterRef.withStyle(.NoStyle, timeStyle: .NoStyle, locale: locale)
        CFDateFormatterSetFormat(formatter, format)
        
        self.properties = properties
        self.format = format
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
}

public enum DateFormatterProperty {
    
    //case Calendar(Calendar) // CFCalendar
    //case TimeZone(TimeZone) // CFTimeZone
    case IsLenient(Bool)
    case CalendarName(String)
    case DefaultFormat(String)
    case TwoDigitStartDate(Date)
    case DefaultDate(Date)
    case EraSymbols([String])
    case MonthSymbols([String])
    case ShortMonthSymbols([String])
    case WeekdaySymbols([String])
    case ShortWeekdaySymbols([String])
    case AMSymbol(StringValue)
    case PMSymbol(StringValue)
    case LongEraSymbols([String])
    case VeryShortMonthSymbols([String])
    case StandaloneMonthSymbols([String])
    case ShortStandaloneMonthSymbols([String])
    case VeryShortStandaloneMonthSymbols([String])
    case VeryShortWeekdaySymbols([String])
    case StandaloneWeekdaySymbols([String])
    case ShortStandaloneWeekdaySymbols([String])
    case VeryShortStandaloneWeekdaySymbols([String])
    case QuarterSymbols([String])
    case ShortQuarterSymbols([String])
    case StandaloneQuarterSymbols([String])
    case ShortStandaloneQuarterSymbols([String])
    case GregorianStartDate(Date)
    case DoesRelativeDateFormattingKey(Bool)
}

// MARK: - Internal

internal final class InternalDateFormatter {
    
    let value: CFDateFormatterRef
    
    init(value: CFDateFormatterRef) {
        
        self.value = value
    }
    
    let internalQueue = dispatch_queue_create("DateFormatter Thread Safety Queue", nil)
    
    func stringFromDate(value: Date) -> String {
        
        var stringValue: String!
        
        dispatch_sync(self.internalQueue) { () -> Void in
            
            stringValue = self.value.stringFromDate(value)
        }
        
        return stringValue
    }
    
    func dateFromString(string: String) -> Date? {
        
        var date: Date?
        
        dispatch_sync(self.internalQueue) { () -> Void in
            
            date = self.value.dateFromString(string)
        }
        
        return date
    }
}


