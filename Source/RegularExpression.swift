//
//  RegularExpression.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/1/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

/** Regular expression interface. */
public protocol RegularExpressionType: RawRepresentable, CustomStringConvertible {
    
    typealias CompileOptions
    
    typealias MatchingOptions
    
    var pattern: String { get }
    
    var options: CompileOptions { get }
    
    init(pattern: String, options: CompileOptions) throws
    
    func match(string: String, options: MatchingOptions) throws -> [Range<UInt>]
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
    
    // MARK: - Properties
    
    public let pattern: String
    
    public let options: [RegularExpressionCompileOption]
    
    // MARK: - Private Properties
    
    private var internalValue: UnsafeMutablePointer<regex_t>!
    
    // MARK: - Initialization
    
    deinit {
        
        regfree(internalValue)
    }
    
    public init(pattern: String, options: [RegularExpressionCompileOption]) throws {
        
        self.pattern = pattern
        self.options = options
        
        self.internalValue = try CompileRegex(pattern, options: options)
    }
    
    public func match(string: String, options: [RegularExpressionMatchOption]) throws -> [Range<UInt>] {
        
        return []
    }
}

