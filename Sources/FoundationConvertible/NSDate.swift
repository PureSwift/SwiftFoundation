//
//  Date.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(Linux)
    import SwiftFoundation
#endif

import Foundation

extension Date: FoundationConvertible {
    
    public init(foundation: NSDate) {
        
        self.init(sinceReferenceDate: foundation.timeIntervalSinceReferenceDate)
    }
    
    public func toFoundation() -> NSDate {
        
        return NSDate(timeIntervalSinceReferenceDate: sinceReferenceDate)
    }
}

