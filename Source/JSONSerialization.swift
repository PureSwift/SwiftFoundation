//
//  JSONSerialization.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/10/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension JSON.Value {
    
    init?(string: Swift.String) {
        
        // clear leading white space
        
        var data = Data()
        
        do {
            
            var startAddingBytes = false
            
            for codeUnit in string.utf8 {
                
                if !startAddingBytes && !codeUnit.isWhitespace() {
                    
                    startAddingBytes = true
                }
                
                data.append(codeUnit)
            }
        }
        
        
    }
}

private extension JSON.Value {
    
    func parse
}

private extension JSON {
    
    private enum Token {
        
        // Control Codes
        static let Linefeed         = UInt8(10)
        static let Backspace        = UInt8(8)
        static let Formfeed         = UInt8(12)
        static let CarriageReturn   = UInt8(13)
        static let HorizontalTab    = UInt8(9)
        
        // Tokens for JSON
        static let LeftBracket      = UInt8(91)
        static let RightBracket     = UInt8(93)
        static let LeftCurly        = UInt8(123)
        static let RightCurly       = UInt8(125)
        static let Comma            = UInt8(44)
        static let SingleQuote      = UInt8(39)
        static let DoubleQuote      = UInt8(34)
        static let Minus            = UInt8(45)
        static let Plus             = UInt8(43)
        static let Backslash        = UInt8(92)
        static let Forwardslash     = UInt8(47)
        static let Colon            = UInt8(58)
        static let Period           = UInt8(46)
        
        // Numbers
        static let Zero             = UInt8(48)
        static let One              = UInt8(49)
        static let Two              = UInt8(50)
        static let Three            = UInt8(51)
        static let Four             = UInt8(52)
        static let Five             = UInt8(53)
        static let Six              = UInt8(54)
        static let Seven            = UInt8(55)
        static let Eight            = UInt8(56)
        static let Nine             = UInt8(57)
        
        // Character tokens for JSON
        static let A                = UInt8(65)
        static let E                = UInt8(69)
        static let F                = UInt8(70)
        static let a                = UInt8(97)
        static let b                = UInt8(98)
        static let e                = UInt8(101)
        static let f                = UInt8(102)
        static let l                = UInt8(108)
        static let n                = UInt8(110)
        static let r                = UInt8(114)
        static let s                = UInt8(115)
        static let t                = UInt8(116)
        static let u                = UInt8(117)
    }
}

private extension UInt8 {
    
    /// Determines if the `UnicodeScalar` represents one of the standard Unicode whitespace characters.
    ///
    /// :return: `true` if the scalar is a Unicode whitespace character; `false` otherwise.
    func isWhitespace() -> Bool {
        if self >= 0x09 && self <= 0x0D        { return true }     // White_Space # Cc   [5] <control-0009>..<control-000D>
        if self == 0x20                        { return true }     // White_Space # Zs       SPACE
        if self == 0x85                        { return true }     // White_Space # Cc       <control-0085>
        if self == 0xA0                        { return true }     // White_Space # Zs       NO-BREAK SPACE
        
        // TODO: These are no longer possible to be hit... does it matter???
        //        if self == 0x1680                      { return true }     // White_Space # Zs       OGHAM SPACE MARK
        //        if self >= 0x2000 && self <= 0x200A    { return true }     // White_Space # Zs  [11] EN QUAD..HAIR SPACE
        //        if self == 0x2028                      { return true }     // White_Space # Zl       LINE SEPARATOR
        //        if self == 0x2029                      { return true }     // White_Space # Zp       PARAGRAPH SEPARATOR
        //        if self == 0x202F                      { return true }     // White_Space # Zs       NARROW NO-BREAK SPACE
        //        if self == 0x205F                      { return true }     // White_Space # Zs       MEDIUM MATHEMATICAL SPACE
        //        if self == 0x3000                      { return true }     // White_Space # Zs       IDEOGRAPHIC SPACE
        
        return false
    }
    
    /// Determines if the `UnicodeScalar` respresents a numeric digit.
    ///
    /// :return: `true` if the scalar is a Unicode numeric character; `false` otherwise.
    func isDigit() -> Bool {
        return self >= JSON.Token.Zero && self <= JSON.Token.Nine
    }
    
    /// Determines if the `UnicodeScalar` respresents a valid terminating character.
    /// :return: `true` if the scalar is a valid terminator, `false` otherwise.
    func isValidTerminator() -> Bool {
        if self == JSON.Token.Comma            { return true }
        if self == JSON.Token.RightBracket     { return true }
        if self == JSON.Token.RightCurly       { return true }
        if self.isWhitespace()                 { return true }
        
        return false
    }
}

