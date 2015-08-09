//
//  POSIXRegularExpression.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public typealias POSIXRegularExpression = regex_t

public extension POSIXRegularExpression {
    
    public typealias FlagBitmask = Int32
    
    public typealias ErrorCode = Int32
    
    public static func compile(pattern: String, options: [RegularExpression.CompileOption]) -> (ErrorCode, POSIXRegularExpression) {
        
        var regularExpression = POSIXRegularExpression()
        
        let flags = options.optionsBitmask()
        
        let errorCode = regcomp(&regularExpression, pattern, flags)
        
        return (errorCode, regularExpression)
    }
    
    public mutating func free() {
        
        regfree(&self)
    }
    
    public func match(string: String, options: [RegularExpression.MatchOption]) throws -> Range<UInt>? {
        
        return nil
    }
}
