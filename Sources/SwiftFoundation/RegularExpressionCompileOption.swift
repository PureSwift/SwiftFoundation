//
//  RegularExpressionCompileOption.swift
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
    
    /// POSIX Regular Expression Compilation Options
    public enum CompileOption: Int32, BitMaskOption {

        /// Do not differentiate case.
        case CaseInsensitive
        
        /// Use POSIX Extended Regular Expression syntax when interpreting regular expression. 
        /// If not set, POSIX Basic Regular Expression syntax is used.
        case ExtendedSyntax
        
        /// Report only success/fail.
        case NoSub
        
        /// Treat a newline in string as dividing string into multiple lines, so that ```$``` can match before the newline and ```^``` can match after. Also, don’t permit ```.``` to match a newline, and don’t permit ```[^…]``` to match a newline.
        ///
        /// Otherwise, newline acts like any other ordinary character.
        case NewLine
        
        public init?(rawValue: POSIXRegularExpression.FlagBitmask) {
            
            switch rawValue {
                
            case REG_ICASE:             self = .CaseInsensitive
            case REG_EXTENDED:          self = .ExtendedSyntax
            case REG_NOSUB:             self = .NoSub
            case REG_NEWLINE:           self = .NewLine
                
            default: return nil
            }
        }
        
        public var rawValue: POSIXRegularExpression.FlagBitmask {
            
            switch self {
                
            case .CaseInsensitive:      return REG_ICASE
            case .ExtendedSyntax:       return REG_EXTENDED
            case .NoSub:                return REG_NOSUB
            case .NewLine:              return REG_NEWLINE
            }
        }
    }
}

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    
    
#elseif os(Linux)
    
    public let REG_EXTENDED: Int32 = 1
    
    public let REG_ICASE: Int32 = (REG_EXTENDED << 1)
    
    public let REG_NEWLINE: Int32 = (REG_ICASE << 1)

    public let REG_NOSUB: Int32 = (REG_NEWLINE << 1)

#endif
