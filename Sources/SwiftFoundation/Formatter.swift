//
//  Formatter.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Defines the interface for supporting conversion between strings and other types of values.
public protocol FormatterType {
    
    associatedtype Value
    
    /// Primary method for converting an object to a string through formatting. Object will be converted to string according to the formatter's implementation and init parameters. */
    func stringFromValue(value: Value) -> String
    
    func valueFromString(string: String) -> Value?
}