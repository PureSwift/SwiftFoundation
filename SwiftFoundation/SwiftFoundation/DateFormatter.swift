//
//  DateFormatter.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public struct DateFormatter: Formatter {
    
    public func stringForValue(value: Date) -> String {
        
        // TODO:
        
        return "\(value)"
    }
    
    public func valueWithString(string: String) -> Date? {
        
        return nil
    }
}