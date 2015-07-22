//
//  POSIXRegularExpression.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - POSIX Regular Expression Functions

public func POSIXRegexCompile(pattern: String, options: [RegularExpressionCompileOption]) throws -> UnsafeMutablePointer<regex_t> {
    
    let regexPointer = UnsafeMutablePointer<regex_t>.alloc(1)
    defer { regexPointer.dealloc(1) }
    
    let flags = RegularExpressionCompileOption.optionsBitmask(options)
    
    let errorCode = regcomp(regexPointer, pattern, flags)
    
    guard errorCode == 0 else {
        
        throw RegularExpressionCompileError(rawValue: errorCode)!
    }
    
    return regexPointer
}

public func POSIXRegexMatch(regex: UnsafeMutablePointer<regex_t>, string: String, options: [RegularExpressionMatchOption]) -> Range<UInt>? {
    
    //let flags = RegularExpressionMatchOption.flagValue(options)
    
    // regexec(regex, string, 100, <#T##__pmatch: UnsafeMutablePointer<regmatch_t>##UnsafeMutablePointer<regmatch_t>#>, flags)
    
    return nil;
}

// MARK: - Supporting Types

// MARK: Options

public typealias POSIXRegularExpressionCompileOptionFlag = Int32

/// POSIX Regular Expression Compilation Options
public enum RegularExpressionCompileOption: POSIXRegularExpressionCompileOptionFlag, BitMaskOption {
    
    /** Do not differentiate case. */
    case CaseInsensitive
    
    /** Use POSIX Extended Regular Expression syntax when interpreting regular expression. If not set, POSIX Basic Regular Expression syntax is used. */
    case ExtendedSyntax
    
    /** Report only success/fail. */
    case NoSub
    
    /// Treat a newline in string as dividing string into multiple lines, so that ```$``` can match before the newline and ```^``` can match after. Also, don’t permit ```.``` to match a newline, and don’t permit ```[^…]``` to match a newline.
    ///
    /// Otherwise, newline acts like any other ordinary character.
    case NewLine
    
    public init?(rawValue: POSIXRegularExpressionCompileOptionFlag) {
        
        switch rawValue {
            
        case REG_ICASE:     self = CaseInsensitive
        case REG_EXTENDED:  self = ExtendedSyntax
        case REG_NOSUB:     self = NoSub
        case REG_NEWLINE:   self = NewLine
            
        default: return nil
        }
    }
    
    public var rawValue: POSIXRegularExpressionCompileOptionFlag {
        
        switch self {
            
        case .CaseInsensitive:  return REG_ICASE
        case .ExtendedSyntax:   return REG_EXTENDED
        case .NoSub:            return REG_NOSUB
        case .NewLine:          return REG_NEWLINE
        }
    }
}

public typealias POSIXRegularExpressionMatchOptionFlag = Int32

/// POSIX Regular Expression Matching Options */
public enum RegularExpressionMatchOption: POSIXRegularExpressionMatchOptionFlag, BitMaskOption {
    
    /** Do not regard the beginning of the specified string as the beginning of a line; more generally, don’t make any assumptions about what text might precede it. */
    case NotBeginningOfLine
    
    /** Do not regard the end of the specified string as the end of a line; more generally, don’t make any assumptions about what text might follow it. */
    case NotEndOfLine
    
    public init?(rawValue: POSIXRegularExpressionMatchOptionFlag) {
        
        switch rawValue {
            
        case REG_NOTBOL: self = NotBeginningOfLine
        case REG_NOTEOL: self = NotEndOfLine
            
        default: return nil
        }
    }
    
    public var rawValue: POSIXRegularExpressionMatchOptionFlag {
        
        switch self {
        
        case .NotBeginningOfLine:   return REG_NOTBOL
        case .NotEndOfLine:         return REG_NOTEOL
        }
    }
}

// MARK: Errors

public typealias POSIXRegularExpressionCompileErrorRawValue = Int32

public enum RegularExpressionCompileError: POSIXRegularExpressionCompileErrorRawValue, ErrorType {
    
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
    
    public init?(rawValue: POSIXRegularExpressionCompileErrorRawValue) {
        
        switch rawValue {
            
        case REG_BADRPT:    self = InvalidRepetition
        case REG_BADBR:     self = InvalidBackReference
        case REG_ESPACE:    self = OutOfMemory
        case REG_BADPAT:    self = InvalidPatternOperator
        case REG_EBRACE:    self = UnMatchedBraceInterval
        case REG_EBRACK:    self = UnMatchedBracketList
        case REG_ECOLLATE:  self = InvalidCollating
        case REG_ECTYPE:    self = UnknownCharacterClassName
        case REG_EESCAPE:   self = TrailingBackslash
        case REG_EPAREN:    self = UnMatchedParenthesis
        case REG_ERANGE:    self = InvalidRange
        case REG_ESUBREG:   self = InvalidBackReferenceToSubExpression
            
            /*
            #if os(linux)
            
            case REG_EEND: self = .GenericError // Linux
            case REG_ESIZE: self = .GreaterThan64KB // Linux
            
            #endif
            */
            
        default: return nil
        }
    }
    
    public var rawValue: POSIXRegularExpressionCompileErrorRawValue {
        
        switch self {
            
        case InvalidRepetition:                    return REG_BADRPT
        case InvalidBackReference:                 return REG_BADBR
        case OutOfMemory:                          return REG_ESPACE
        case InvalidPatternOperator:               return REG_BADPAT
        case UnMatchedBraceInterval:               return REG_EBRACE
        case UnMatchedBracketList:                 return REG_EBRACK
        case InvalidCollating:                     return REG_ECOLLATE
        case UnknownCharacterClassName:            return REG_ECTYPE
        case TrailingBackslash:                    return REG_EESCAPE
        case UnMatchedParenthesis:                 return REG_EPAREN
        case InvalidRange:                         return REG_ERANGE
        case InvalidBackReferenceToSubExpression:  return REG_ESUBREG
        }
    }
}
