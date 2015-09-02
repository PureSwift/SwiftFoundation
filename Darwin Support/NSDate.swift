//
//  Date.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

public extension Date {
    
    init(foundation: NSDate) {
        
        self.init(timeIntervalSinceReferenceDate: foundation.timeIntervalSinceReferenceDate)
    }
    
    func toFoundation() -> NSDate {
        
        return NSDate(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDate)
    }
}

