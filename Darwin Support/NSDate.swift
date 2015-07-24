//
//  Date.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

public extension NSDate {
    
    convenience init(date: Date) {
        
        self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
    }
    
    func toDate() -> Date {
        
        return Date(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate)
    }
}