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

/** POSIX Regular Expression. */
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

// MARK: - Supporting Types

// MARK: Options

/** POSIX Regular Expression Compilation Options */
public enum RegularExpressionCompileOption {
    
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
    
    // MARK: Private Conversion
    
    private var cFlagValue: Int32 {
        
        switch self {
            
        case .CaseInsensitive: return REG_ICASE
            
        case .ExtendedSyntax: return REG_EXTENDED
            
        case .NoSub: return REG_NOSUB
            
        case .NewLine: return REG_NEWLINE
            
        }
    }
}

/** POSIX Regular Expression Matching Options */
public enum RegularExpressionMatchOption {
    
    /** Do not regard the beginning of the specified string as the beginning of a line; more generally, don’t make any assumptions about what text might precede it. */
    case NotBeginningOfLine
    
    /** Do not regard the end of the specified string as the end of a line; more generally, don’t make any assumptions about what text might follow it. */
    case NotEndOfLine
    
    // MARK: Private Conversion
    
    private var eFlagValue: Int32 {
        
        switch self {
            
        case .NotBeginningOfLine: return REG_NOTBOL
            
        case .NotEndOfLine: return REG_NOTEOL
        }
    }
}

// MARK: Errors

public enum RegularExpressionCompileError: ErrorType {
    
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
    
    /// Non specific error.  This is not defined by POSIX.2.
    case GenericError
    
    /// Compiled regular expression requires a pattern buffer larger than 64Kb. This is not defined by POSIX.2.
    case GreaterThan64KB
    
    // MARK: Private Conversion
    
    private init?(eFlagValue: Int32) {
        
        switch eFlagValue {
            
            case REG_BADRPT: self = .InvalidRepetition
            case REG_BADBR: self = .InvalidBackReference
            case REG_ESPACE: self = .OutOfMemory
            case REG_EBRACE: self = .UnMatchedBraceInterval
            case REG_ECOLLATE: self = .InvalidCollating
            case REG_ECTYPE: self = .UnknownCharacterClassName
            case REG_EESCAPE: self = .TrailingBackslash
            case REG_EPAREN: self = .UnMatchedParenthesis
            case REG_ERANGE: self = .InvalidRange
            case REG_ESUBREG: self = .InvalidBackReferenceToSubExpression
            
            /*
            #if os(linux)
            
            case REG_EEND: self = .GenericError // Linux
            case REG_ESIZE: self = .GreaterThan64KB // Linux
                
            #endif
            */            

            default: return nil
        }
    }
}

// MARK: - Private POSIX Regular Expression Functions

private func CompileRegex(pattern: String, options: [RegularExpressionCompileOption]) throws -> UnsafeMutablePointer<regex_t> {
    
    let regexPointer = UnsafeMutablePointer<regex_t>.alloc(1)
    defer { regexPointer.dealloc(1) }
    
    let regexCompileFlags: Int32 = {
        
        var cFlag: Int32 = 0
        
        for option in options {
            
            cFlag = cFlag | option.cFlagValue
        }
        
        return cFlag
    }()
    
    let errorCode = regcomp(regexPointer, pattern, regexCompileFlags)
    
    guard errorCode == 0 else {
        
        throw RegularExpressionCompileError(eFlagValue: errorCode)!
    }
    
    return regexPointer
}


private func MatchRegex(regex: UnsafeMutablePointer<regex_t>, string: String, options: [RegularExpressionMatchOption]) -> Range<UInt>? {
    
    let flags: Int32 = {
       
        var eFlag: Int32 = 0
        
        for option in options {
            
            eFlag = eFlag | option.eFlagValue
        }
        
        return eFlag
    }()
    
    // regexec(regex, string, 100, <#T##__pmatch: UnsafeMutablePointer<regmatch_t>##UnsafeMutablePointer<regmatch_t>#>, flags)
    
    return nil;
}

