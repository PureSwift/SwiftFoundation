//
//  CFDateFormatter.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import CoreFoundation

public extension CFDateFormatterRef {
    
    static func dateFormatter() -> CFDateFormatterRef {
        
        return CFDateFormatterCreate(nil, nil, .NoStyle, .NoStyle)
    }
    
    static func withStyle(dateStyle: DateFormatterStyle, timeStyle: DateFormatterStyle, locale: Locale? = nil) -> CFDateFormatter {
        
        // to get same behavior as NSDateFormatter
        let locale = locale ?? Locale.currentLocale
                
        return CFDateFormatterCreate(nil, locale.internalLocale, CFDateFormatterStyle(style: dateStyle), CFDateFormatterStyle(style: timeStyle))
    }
    
    var format: String {
        
        get { return CFDateFormatterGetFormat(self) as String }
        set { CFDateFormatterSetFormat(self, format) }
    }
    
    func setProperties(properties: [DateFormatterProperty]) {
        
        for property in properties {
            
            CFDateFormatterSetProperty(self, property.CFPropertyName, property.toCFValue())
        }
    }
    
    func dateFromString(string: String) -> Date? {
        
        return CFDateFormatterCreateDateFromString(nil, self, string, nil).toDate()
    }
    
    func stringFromDate(date: Date) -> String {
        
        let string = CFDateFormatterCreateStringWithDate(nil, self, CFDate.fromDate(date))
        
        return string as String
    }
}

public extension CFDateFormatterStyle {
    
    init(style: DateFormatterStyle) {
        
        switch style {
            
        case .NoStyle:      self = .NoStyle
        case .ShortStyle:   self = .ShortStyle
        case .MediumStyle:  self = .MediumStyle
        case .LongStyle:    self = .LongStyle
        case .FullStyle:    self = .FullStyle
        }
    }
    
    func toDateFormatterStyle() -> DateFormatterStyle {
        
        switch self {
            
        case NoStyle:       return .NoStyle
        case ShortStyle:    return .ShortStyle
        case MediumStyle:   return .MediumStyle
        case LongStyle:     return .LongStyle
        case FullStyle:     return .FullStyle
        }
    }
}

public extension DateFormatterProperty {
    
    func toCFValue() -> AnyObject {
        
        switch self {
            
        case IsLenient(let value): return value
        case CalendarName(let value): return value
        case DefaultFormat(let value): return value
        case TwoDigitStartDate(let value): return CFDateRef.fromDate(value)
        case DefaultDate(let value): return CFDateRef.fromDate(value)
        case EraSymbols(let value): return value
        case MonthSymbols(let value): return value
        case ShortMonthSymbols(let value): return value
        case WeekdaySymbols(let value): return value
        case ShortWeekdaySymbols(let value): return value
        case AMSymbol(let value): return value
        case PMSymbol(let value): return value
        case LongEraSymbols(let value): return value
        case VeryShortMonthSymbols(let value): return value
        case StandaloneMonthSymbols(let value): return value
        case ShortStandaloneMonthSymbols(let value): return value
        case VeryShortStandaloneMonthSymbols(let value): return value
        case VeryShortWeekdaySymbols(let value): return value
        case StandaloneWeekdaySymbols(let value): return value
        case ShortStandaloneWeekdaySymbols(let value): return value
        case VeryShortStandaloneWeekdaySymbols(let value): return value
        case QuarterSymbols(let value): return value
        case ShortQuarterSymbols(let value): return value
        case StandaloneQuarterSymbols(let value): return value
        case ShortStandaloneQuarterSymbols(let value): return value
        case GregorianStartDate(let value): return CFDateRef.fromDate(value)
        case DoesRelativeDateFormattingKey(let value): return value
        
        }
    }
    
    var CFPropertyName: String {
        
        switch self {
            
        case IsLenient(_): return kCFDateFormatterIsLenient as String
        case CalendarName(_): return kCFDateFormatterCalendarName as String
        case DefaultFormat(_): return kCFDateFormatterDefaultFormat as String
        case TwoDigitStartDate(_): return kCFDateFormatterTwoDigitStartDate as String
        case DefaultDate(_): return kCFDateFormatterDefaultDate as String
        case EraSymbols(_): return kCFDateFormatterEraSymbols as String
        case MonthSymbols(_): return kCFDateFormatterMonthSymbols as String
        case ShortMonthSymbols(_): return kCFDateFormatterShortMonthSymbols as String
        case WeekdaySymbols(_): return kCFDateFormatterWeekdaySymbols as String
        case ShortWeekdaySymbols(_): return kCFDateFormatterShortWeekdaySymbols as String
        case AMSymbol(_): return kCFDateFormatterAMSymbol as String
        case PMSymbol(_): return kCFDateFormatterPMSymbol as String
        case LongEraSymbols(_): return kCFDateFormatterLongEraSymbols as String
        case VeryShortMonthSymbols(_): return kCFDateFormatterVeryShortMonthSymbols as String
        case StandaloneMonthSymbols(_): return kCFDateFormatterStandaloneMonthSymbols as String
        case ShortStandaloneMonthSymbols(_): return kCFDateFormatterShortStandaloneMonthSymbols as String
        case VeryShortStandaloneMonthSymbols(_): return kCFDateFormatterVeryShortStandaloneMonthSymbols as String
        case VeryShortWeekdaySymbols(_): return kCFDateFormatterVeryShortStandaloneMonthSymbols as String
        case StandaloneWeekdaySymbols(_): return kCFDateFormatterStandaloneWeekdaySymbols as String
        case ShortStandaloneWeekdaySymbols(_): return kCFDateFormatterShortStandaloneWeekdaySymbols as String
        case VeryShortStandaloneWeekdaySymbols(_): return kCFDateFormatterVeryShortStandaloneWeekdaySymbols as String
        case QuarterSymbols(_): return kCFDateFormatterQuarterSymbols as String
        case ShortQuarterSymbols(_): return kCFDateFormatterShortQuarterSymbols as String
        case StandaloneQuarterSymbols(_): return kCFDateFormatterShortStandaloneQuarterSymbols as String
        case ShortStandaloneQuarterSymbols(_): return kCFDateFormatterShortStandaloneQuarterSymbols as String
        case GregorianStartDate(_): return kCFDateFormatterGregorianStartDate as String
        case DoesRelativeDateFormattingKey(_): return kCFDateFormatterDoesRelativeDateFormattingKey as String
            
        }
    }
}
