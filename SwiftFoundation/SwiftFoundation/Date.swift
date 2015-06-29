//
//  Date.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public struct Date {
    
    // MARK: - Static Properties
    
    /** Returns the time interval between the current date and the reference date (1 January 2001, GMT). */
    public static func timeIntervalSinceReferenceDate() -> TimeInterval {
        
        
    }
    
    // MARK: - Properties
    
    public let timeIntervalSinceReferenceDate: TimeInterval
    
    // MARK: - Initialization
    
    public init(timeIntervalSinceReferenceDate: TimeInterval) {
        
        self.timeIntervalSinceReferenceDate = timeIntervalSinceReferenceDate
    }
    
    public init() {
        
        self.timeIntervalSinceReferenceDate = Date.timeIntervalSinceReferenceDate()
    }
    
    // MARK: - Static Methods
}

// MARK: - Constants

/** Time interval difference between two dates, in seconds. */
public typealias TimeInterval = Double

///
/// Time interval between the unix standard reference date of 1 January 1970 and the OpenStep reference date of 1 January 2001
/// This number comes from:
///
/// ```(((31 years * 365 days) + 8  *(days for leap years)* */) = /* total number of days */ * 24 hours * 60 minutes * 60 seconds)```
///
/// - note: This ignores leap-seconds
public let TimeIntervalSince1970: TimeInterval = 978307200.0