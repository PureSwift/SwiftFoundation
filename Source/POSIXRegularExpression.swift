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
    
    
    public func firstMatch(string: String, options: [RegularExpression.MatchOption]) -> RegularExpressionMatch? {
        
        // we are sure that that this method does not mutate the regular expression, so we make a copy
        var expression = self
        
        let numberOfMatches = re_nsub + 1 // first match is the expression itself, later matches are subexpressions
        
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
        
        var match = RegularExpressionMatch()
        
        do {
            let expressionMatch = matches[0]
            
            match.range = Swift.Range(start: Int(expressionMatch.rm_so), end: Int(expressionMatch.rm_eo))
        }
        
        let subexpressionsCount = re_nsub // REMOVE
        
        if subexpressionsCount > 0 {
            
            // Index for subexpressions start at 1, not 0
            for index in 1...subexpressionsCount {
                
                let subexpressionMatch = matches[Int(index)]
                
                guard subexpressionMatch.rm_so != -1 else {
                    
                    match.subexpressionRanges.append(RegularExpressionMatch.Range.NotFound)
                    continue
                }
                
                let range = Swift.Range(start: Int(subexpressionMatch.rm_so), end: Int(subexpressionMatch.rm_eo))
                
                match.subexpressionRanges.append(RegularExpressionMatch.Range.Found(range))
            }
        }
        
        return match
    }
}
