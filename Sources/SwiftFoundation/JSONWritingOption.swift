//
//  JSONWritingOption.swift
//  JSONC
//
//  Created by Alsey Coleman Miller on 12/19/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import JSON
#elseif os(Linux)
    import CJSONC
#endif

public extension JSON {
    
    /// Options for serializing JSON.
    ///
    /// - Note: Uses the [JSON-C](https://github.com/json-c/json-c) library.
    public enum WritingOption: BitMaskOption {
        
        /// Causes the output to have minimal whitespace inserted to make things slightly more readable.
        case Spaced
        
        /// Causes the output to be formatted. See the [Two Space Tab](http://jsonformatter.curiousconcept.com/) option
        /// for an example of the format.
        case Pretty
        
        /// Drop trailing zero for float values
        case NoZero
        
        public init?(rawValue: Int32) {
            
            switch rawValue {
                
            case JSON_C_TO_STRING_SPACED:       self = .Spaced
            case JSON_C_TO_STRING_PRETTY:       self = .Pretty
            case JSON_C_TO_STRING_NOZERO:       self = .NoZero
                
            default: return nil
            }
        }
        
        public var rawValue: Int32 {
            
            switch self {
                
            case Spaced:        return JSON_C_TO_STRING_SPACED
            case Pretty:        return JSON_C_TO_STRING_PRETTY
            case NoZero:        return JSON_C_TO_STRING_NOZERO
            }
        }
    }
}

