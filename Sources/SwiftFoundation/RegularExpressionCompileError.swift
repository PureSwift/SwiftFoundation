//
//  RegularExpressionCompileError.swift
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
    
    // POSIX Regular Expression compilation error
    public enum CompileError: Error, RawRepresentable {
        
        /// Invalid use  of repetition operators such as using '*' as the first character.
        ///
        /// For example, the consecutive repetition operators ```**``` in ```a**``` are invalid. As another example, if the syntax is extended regular expression syntax, then the repetition operator ```*``` with nothing on which to operate in ```*``` is invalid.
        case InvalidRepetition
        
        /// Invalid use of back reference operator.
        ///
        /// For example, the count '```-1```' in '```a\{-1```' is invalid.
        case InvalidBackReference
        
        /// The regex routines ran out of memory.
        case OutOfMemory
        
        /// Invalid use of pattern operators such as group or list.
        case InvalidPatternOperator
        
        /// Un-matched brace interval operators.
        case UnMatchedBraceInterval
        
        /// Un-matched bracket list operators.
        case UnMatchedBracketList
        
        /// Invalid collating element.
        case InvalidCollating
        
        /// Unknown character class name.
        case UnknownCharacterClassName
        
        /// Trailing backslash.
        case TrailingBackslash
        
        /// Un-matched parenthesis group operators.
        case UnMatchedParenthesis
        
        /// Invalid use of the range operator.
        ///
        /// E.g. The ending point  of  the range occurs prior to the starting point.
        case InvalidRange
        
        /// Invalid back reference to a subexpression.
        case InvalidBackReferenceToSubExpression
        
        /* Linux
        /// Non specific error.  This is not defined by POSIX.2.
        case GenericError
        
        /// Compiled regular expression requires a pattern buffer larger than 64Kb. This is not defined by POSIX.2.
        case GreaterThan64KB
        */
        
        public init?(rawValue: POSIXRegularExpression.ErrorCode) {
            
            switch rawValue {
                
            case REG_BADRPT:                            self = .InvalidRepetition
            case REG_BADBR:                             self = .InvalidBackReference
            case REG_ESPACE:                            self = .OutOfMemory
            case REG_BADPAT:                            self = .InvalidPatternOperator
            case REG_EBRACE:                            self = .UnMatchedBraceInterval
            case REG_EBRACK:                            self = .UnMatchedBracketList
            case REG_ECOLLATE:                          self = .InvalidCollating
            case REG_ECTYPE:                            self = .UnknownCharacterClassName
            case REG_EESCAPE:                           self = .TrailingBackslash
            case REG_EPAREN:                            self = .UnMatchedParenthesis
            case REG_ERANGE:                            self = .InvalidRange
            case REG_ESUBREG:                           self = .InvalidBackReferenceToSubExpression
                
                /*
                #if os(linux)
                
                case REG_EEND: self = .GenericError // Linux
                case REG_ESIZE: self = .GreaterThan64KB // Linux
                
                #endif
                */
                
            default: return nil
            }
        }
        
        public var rawValue: POSIXRegularExpression.ErrorCode {
            
            switch self {
                
            case .InvalidRepetition:                     return REG_BADRPT
            case .InvalidBackReference:                  return REG_BADBR
            case .OutOfMemory:                           return REG_ESPACE
            case .InvalidPatternOperator:                return REG_BADPAT
            case .UnMatchedBraceInterval:                return REG_EBRACE
            case .UnMatchedBracketList:                  return REG_EBRACK
            case .InvalidCollating:                      return REG_ECOLLATE
            case .UnknownCharacterClassName:             return REG_ECTYPE
            case .TrailingBackslash:                     return REG_EESCAPE
            case .UnMatchedParenthesis:                  return REG_EPAREN
            case .InvalidRange:                          return REG_ERANGE
            case .InvalidBackReferenceToSubExpression:   return REG_ESUBREG
            }
        }
    }
}

