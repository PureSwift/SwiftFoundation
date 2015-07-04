//
//  RegularExpression.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/1/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

/** Regular expression interface. */
public protocol RegularExpressionType: RawRepresentable, CustomStringConvertible, Equatable {
    
    typealias OptionsType
    
    var pattern: String { get }
    
    var options: OptionsType { get }
    
    init(pattern: String, options: OptionsType) throws
}

// MARK: - Protocol Implementation

public extension RegularExpressionType {
    
    init?(rawValue: (String, OptionsType)) {
        
        do {
            
            try self.init(pattern: rawValue.0, options: rawValue.1)
        }
        catch _ {
            
            return nil
        }
    }
    
    var rawValue: (String, OptionsType) {
        
        return (pattern, options)
    }
    
    var description: String {
        
        return "Options: \(options) Pattern: \(pattern)"
    }
}

// MARK: - Implementation

/*
/** POSIX Regular Expression. */
public struct RegularExpression: RegularExpressionType {
    
    // MARK: - Properties
    
    public let pattern: String
    
    public let options: RegularExpressionOptions
    
    // MARK: - Internal Properties
    
    private let internalRegularExpression: regex_t
    
    // MARK: - Initialization
    
    public init(pattern: String, options: RegularExpressionOptions) throws {
        
        // create internal representation
        
        
        
        // set values
        
        self.pattern = pattern
        self.options = options
    }
}

// MARK: - Operator Overloading

public func ==(lhs: RegularExpression, rhs: RegularExpression) -> Bool {
    
    return (lhs.pattern == rhs.pattern && lhs.options == rhs.options)
}

// MARK: - Supporting Types

/** POSIX Regular Expression Options */
public struct RegularExpressionOptions {
    
    
}
*/
