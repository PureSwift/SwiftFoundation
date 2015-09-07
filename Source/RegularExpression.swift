//
//  RegularExpression.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/1/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

// MARK: - Protocol

/** Regular expression interface. */
public protocol RegularExpressionType: RawRepresentable, CustomStringConvertible {
    
    typealias CompileOptions
    
    typealias MatchOptions
    
    var pattern: String { get }
    
    var options: CompileOptions { get }
    
    var subexpressionsCount: Int { get }
    
    init(pattern: String, options: CompileOptions) throws
    
    /// Finds the first match in the string
    func match(string: String, options: MatchOptions) -> RegularExpressionMatch?
    
    
}

// MARK: - Protocol Implementation

public extension RegularExpressionType {
    
    init?(rawValue: (String, CompileOptions)) {
        
        do {
            
            try self.init(pattern: rawValue.0, options: rawValue.1)
        }
        catch _ {
            
            return nil
        }
    }
    
    var rawValue: (String, CompileOptions) {
        
        return (pattern, options)
    }
    
    var description: String {
        
        return "Options: \(options) Pattern: \(pattern)"
    }
}

// MARK: - Implementation

/// POSIX Regular Expression.
final public class RegularExpression: RegularExpressionType {
    
    public typealias Match = RegularExpressionMatch
        
    // MARK: - Properties
    
    public let pattern: String
    
    public let options: [CompileOption]
    
    public var subexpressionsCount: Int {
        
        return internalExpression.re_nsub
    }
    
    // MARK: - Private Properties
    
    private var internalExpression: POSIXRegularExpression
    
    // MARK: - Initialization
    
    deinit {
        
        internalExpression.free()
    }
    
    public init(pattern: String, options: [RegularExpression.CompileOption] = []) throws {
        
        self.pattern = pattern
        self.options = options
        
        let (code, expression) = POSIXRegularExpression.compile(pattern, options: options)
        
        self.internalExpression = expression

        guard code == 0 else { throw CompileError(rawValue: code)! }
    }
    
    public func match(string: String, options: [RegularExpression.MatchOption]) -> Match? {
        
        guard let matches = internalExpression.firstMatch(string, options: options) else { return nil }
        
        var match = RegularExpressionMatch()
        
        do {
            let expressionMatch = matches[0]
            
            match.range = Swift.Range(start: Int(expressionMatch.rm_so), end: Int(expressionMatch.rm_eo))
        }
        
        if subexpressionsCount > 0 {
            
            // Index for subexpressions start at 1, not 0
            for index in 1...(subexpressionsCount - 1) {
                
                let subexpressionMatch = matches[Int(index)]
                
                guard subexpressionMatch.rm_so != -1 else {
                    
                    match.subexpressionRanges.append(Match.Range.NotFound)
                    continue
                }
                
                let range = Swift.Range(start: Int(subexpressionMatch.rm_so), end: Int(subexpressionMatch.rm_eo))
                
                match.subexpressionRanges.append(Match.Range.Found(range))
            }
        }
        
        return match
    }
}

// MARK: - Supporting Types

/// Regular Expression Match
public struct RegularExpressionMatch {
    
    public enum Range {
        
        case NotFound
        
        case Found(Swift.Range<Int>)
    }
    
    /// The range of the match of the regular expression.
    public var range: Swift.Range<Int>
    
    /// The ranges of the regular expression's subexpressions.
    public var subexpressionRanges: [Range]
    
    public init() {
        
        self.range = Swift.Range<Int>(start: 0, end: 0)
        self.subexpressionRanges = []
    }
    
    public init(range: Swift.Range<Int>, subexpressionRanges: [Range]) {
        
        self.range = range
        self.subexpressionRanges = subexpressionRanges
    }
}

