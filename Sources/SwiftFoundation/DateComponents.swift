//
//  DateComponents.swift
//  SwiftFoundation
//
//  Created by David Ask on 07/12/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
    import Foundation
#elseif os(Linux)
    import Glibc
#endif

public struct DateComponents {
    
    public enum Component {
        case second
        case minute
        case hour
        case dayOfMonth
        case month
        case year
        case weekday
        case dayOfYear
    }
    
    public var second: Int32 = 0
    public var minute: Int32 = 0
    public var hour: Int32 = 0
    public var dayOfMonth: Int32 = 1
    public var month: Int32 = 1
    public var year: Int32 = 0
    public var weekday: Int32
    public var dayOfYear: Int32 = 1
    
    /// Intializes from a time interval interval between the current date and 1 January 1970, GMT.
    public init(timeIntervalSince1970 timeinterval: TimeInterval) {
        
        self.init(brokenDown: tm(UTCSecondsSince1970: timeval(timeInterval: timeinterval).tv_sec ))
    }
    
    public init() {
        weekday = 0
    }
    
    /// Initializes from a `Date`.
    public init(date: Date) {
        
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    public var date: Date {
        
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    /// Get the value for the specified component.
    public subscript(component: Component) -> Int32 {
        
        get {
            
            switch component {
            case .second:
                return second
            case .minute:
                return minute
            case .hour:
                return hour
            case .dayOfMonth:
                return dayOfMonth
            case .month:
                return month
            case .year:
                return year
            case .weekday:
                return weekday
            case .dayOfYear:
                return dayOfYear
            }
        }
        
        set {
            
            switch component {
            case .second:
                second = newValue
                break
            case .minute:
                minute = newValue
                break
            case .hour:
                hour = newValue
                break
            case .dayOfMonth:
                dayOfMonth = newValue
                break
            case .month:
                month = newValue
                break
            case .year:
                year = newValue
                break
            case .weekday:
                weekday = newValue
                break
            case .dayOfYear:
                dayOfYear = newValue
                break
            }
        }
    }
    
    private init(brokenDown: tm) {
        second = brokenDown.tm_sec
        minute = brokenDown.tm_min
        hour = brokenDown.tm_hour
        dayOfMonth = brokenDown.tm_mday
        month = brokenDown.tm_mon + 1
        year = 1900 + brokenDown.tm_year
        weekday = brokenDown.tm_wday
        dayOfYear = brokenDown.tm_yday
    }
    
    private var brokenDown: tm {
        return tm.init(
            tm_sec: second,
            tm_min: minute,
            tm_hour: hour,
            tm_mday: dayOfMonth,
            tm_mon: month - 1,
            tm_year: year - 1900,
            tm_wday: weekday,
            tm_yday: dayOfYear,
            tm_isdst: -1,
            tm_gmtoff: 0,
            tm_zone: nil
        )
    }
    
    private var timeInterval: TimeInterval {
        var time = brokenDown
        return TimeInterval(timegm(&time))
    }
}
