//
//  CFDate.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension CFDateRef {
    
    static func fromDate(date: Date) -> CFDateRef {
        
        return CFDateCreate(nil, date.timeIntervalSinceReferenceDate)
    }
    
    func toDate() -> Date {
        
        return Date(timeIntervalSinceReferenceDate: CFDateGetAbsoluteTime(self))
    }
    
}