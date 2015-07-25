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