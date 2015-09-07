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
    
    public typealias Match = regmatch_t
    
    public static func compile(pattern: String, options: [RegularExpression.CompileOption]) -> (ErrorCode, POSIXRegularExpression) {
        
        var regularExpression = POSIXRegularExpression()
        
        let flags = options.optionsBitmask()
        
        let errorCode = regcomp(&regularExpression, pattern, flags)
        
        return (errorCode, regularExpression)
    }
    
    public mutating func free() {
        
        regfree(&self)
    }
    
    public func firstMatch(string: String, options: [RegularExpression.MatchOption]) -> [Match]? {
        
        // we are sure that that this method does not mutate the regular expression, so we make a copy
        var expression = self
        
        let numberOfMatches = re_nsub + 1
        
        let matchesPointer = UnsafeMutablePointer<Match>.alloc(numberOfMatches)
        defer { matchesPointer.destroy(numberOfMatches) }
        
        let flags = options.optionsBitmask()
        
        let code = regexec(&expression, string, numberOfMatches, matchesPointer, flags)
        
        guard code == 0 else { return nil }
        
        var matches = [Match]()
        
        for i in 0...re_nsub {
            
            let match = matchesPointer[i]
            
            matches.append(match)
        }
        
        return matches
    }
}
