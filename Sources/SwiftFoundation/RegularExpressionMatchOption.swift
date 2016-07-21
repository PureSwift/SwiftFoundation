//
//  RegularExpressionMatchOption.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/9/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
#endif

public extension RegularExpression {
    
    /// POSIX Regular Expression Matching Options */
    public enum MatchOption: Int32, BitMaskOption {
                
        /// Do not regard the beginning of the specified string as the beginning of a line;
        /// more generally, don’t make any assumptions about what text might precede it.
        case NotBeginningOfLine
        
        /// Do not regard the end of the specified string as the end of a line;
        /// more generally, don’t make any assumptions about what text might follow it.
        case NotEndOfLine
        
        public init?(rawValue: POSIXRegularExpression.FlagBitmask) {
            
            switch rawValue {
                
            case REG_NOTBOL:            self = .NotBeginningOfLine
            case REG_NOTEOL:            self = .NotEndOfLine
                
            default: return nil
            }
        }
        
        public var rawValue: POSIXRegularExpression.FlagBitmask {
            
            switch self {
                
            case .NotBeginningOfLine:   return REG_NOTBOL
            case .NotEndOfLine:         return REG_NOTEOL
            }
        }
    }
}
