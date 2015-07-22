//
//  Date.swift
//  SwiftFoundationAppleBridge
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import SwiftFoundation

public extension NSDate {
    
    convenience init(date: Date) {
        
        self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
    }
    
    func toDate() -> Date {
        
        return Date(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate)
    }
}