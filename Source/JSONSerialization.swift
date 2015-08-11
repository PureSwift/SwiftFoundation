//
//  JSONSerialization.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/10/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension JSON.Value {
    
    init?(string: Swift.String) {
        
        switch string {
            
            case "null": self = .Null
            case "true": self = .Number(.Boolean(true))
            case "false": self = .Number(.Boolean(false))
        }
    }
}

public extension JSON {
    
    public enum Token {
        
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

