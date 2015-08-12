//
//  JSONParse.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/10/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//
// Based on David Owens II's JSON parser in Swift
// https://github.com/owensd/json-swift
//

public extension JSON.Value {
    
    /// creates JSON from string
    init?(string: Swift.String) {
        
        let data: Data = string.utf8.map({ (codeUnit: UTF8.CodeUnit) -> Byte in
            return codeUnit as Byte
        })
        
        self.init(UTF8Data: data)
    }
    
    /// Parses UTF-8 Data for a JSON value
    ///
    /// - parameter data: The data array that will be parsed.
    ///
    init?(UTF8Data data: Data) {
        
        var index = 0
        
        self.init(UTF8Data: data, index: &index)
    }
    
    /// Parses UTF-8 Data for a JSON value
    ///
    /// - parameter data: The data array that will be parsed.
    ///
    /// - parameter index: The index of the data array where the parsing should start. Defaults to 0.
    ///
    private init?(UTF8Data data: Data, inout index: Int) {
        
        for (index; index < data.count; index++) {
            
            let codeUnit = data[index]
            
            if codeUnit.isWhitespace() { continue }
            
            if codeUnit == JSON.Token.LeftCurly {
            
                guard let value = JSON.parseObject(data, index: &index) else { return nil }
                
                self = JSON.Value.Object(value)
                
                return
            }
                
            else if codeUnit == JSON.Token.LeftBracket {
                
                guard let value = JSON.parseArray(data, index: &index) else { return nil }
                
                self = JSON.Value.Array(value)
                
                return
            }
            
            else if codeUnit.isDigit() || codeUnit == JSON.Token.Minus {
                
                guard let value = JSON.parseNumber(data, index: &index) else { return nil }
                
                self = JSON.Value.Number(value)
                
                return
            }
                
            else if codeUnit == JSON.Token.t {
                
                guard JSON.parseTrue(data, index: &index) else { return nil }
                
                self = JSON.Value.Number(.Boolean(true))
                
                return
            }
            
            else if codeUnit == JSON.Token.f {
                
                guard JSON.parseFalse(data, index: &index) else { return nil }
                
                self = JSON.Value.Number(.Boolean(false))
                
                return
            }
            
            else if codeUnit == JSON.Token.n {
                
                guard JSON.parseNull(data, index: &index) else { return nil }
                
                self = JSON.Value.Number(.Boolean(false))
                
                return
            }
                
            else if codeUnit == JSON.Token.DoubleQuote || codeUnit == JSON.Token.SingleQuote {
                
                guard let value = JSON.parseString(data, index: &index, quote: codeUnit) else { return nil }
                
                self = JSON.Value.String(value)
                
                return
            }
            
            // invalid starting character
            break
        }
        
        return nil
    }
}

// MARK: - Supporting Types

private extension JSON {
    
    private struct Token {
        
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
    
    private enum ObjectParsingState {
        
        case Initial
        case Key
        case Value
        
        init() { self = .Initial }
    }
    
    enum NumberParsingState {
        
        case Initial
        case Whole
        case Decimal
        case Exponent
        case ExponentDigits
        
        init() { self = .Initial }
    }
}

// MARK: - Parsing Functions

private extension JSON {
    
    /// Parses UTF-8 Data for a JSON object
    ///
    /// - parameter data: The data array that will be parsed
    ///
    /// - parameter index: The index of the data array where the parsing should start.
    ///
    static private func parseObject(data: Data, inout index: Int) -> [String: JSON.Value]? {
        
        var state = JSON.ObjectParsingState()
        
        var key = ""
        
        var object = [StringValue: JSONValue]()
        
        for (index; index < data.count; index++) {
            
            let codeUnit = data[index]
            
            switch (index, codeUnit) {
                
            case (0, JSON.Token.LeftCurly): continue
                
            case (_, JSON.Token.RightCurly):
                
                switch state {
                    
                case .Initial, .Value:
                    
                    index++ // eat the '}'
                    
                    return object
                    
                default: return nil // Expected }
                }
                
            case (_, JSON.Token.SingleQuote), (_, JSON.Token.DoubleQuote):
                
                switch state {
                    
                case .Initial:
                    
                    state = .Key
                    
                    guard let parsedKey = parseString(data, index: &index, quote: codeUnit) else { return nil }
                    
                    key = parsedKey
                    
                default: return nil // expected ' or "
                }
                
            case (_, JSON.Token.Colon):
                
                switch state {
                    
                case .Key:
                    
                    state = .Value
                    
                    guard let parsedValue = JSON.Value(UTF8Data: data, index: &index) else { return nil }
                    
                    object[key] = parsedValue
                    
                default: return nil
                }
                
            case (_, JSON.Token.Comma):
                switch state {
                    
                case .Value:
                    state = .Initial
                    key = ""
                    
                default: return nil // expected ,
                }
                
            default:
                
                if codeUnit.isWhitespace() { continue }
                
                else { return nil } // unexpected token
            }
        }
        
        return nil // unable to parse object
    }
    
    static private func parseArray(data: Data, inout index: Int) -> [JSON.Value]? {
        
        var index = index
        
        var values = [JSONValue]()
        
        for (index; index < data.count; index++) {
            
            let codeUnit = data[index]
            
            switch (index, codeUnit) {
                
            case (0, JSON.Token.LeftBracket): continue
                
            case (_, JSON.Token.RightBracket):
                
                index++ // eat the ']'
                
                return values
                
            default:
                
                if codeUnit.isWhitespace() || codeUnit == JSON.Token.Comma { continue }
                
                guard let parsedValue = JSON.Value(UTF8Data: data, index: &index) else { return nil }
                
                values.append(parsedValue)
            }
        }
        
        return nil // unable to parse array
    }
    
    /// Parses data for non-boolean number.
    static private func parseNumber(data: Data, inout index: Int) -> JSON.Number? {
        
        var index = index
        
        var state = NumberParsingState()
        
        var number = 0.0
        var numberSign = 1.0
        var depth = 0.1
        var exponent = 0
        var exponentSign = 1
        
        for (index; index < data.count; index++) {
            
            let codeUnit = data[index]
            
            switch (index, codeUnit, state) {
                
            case (0, Token.Minus, NumberParsingState.Initial):
                numberSign = -1
                state = .Whole
                
            case (_, Token.Minus, NumberParsingState.Exponent):
                exponentSign = -1
                state = .ExponentDigits
                
            case (_, Token.Plus, NumberParsingState.Initial):
                state = .Whole
                
            case (_, Token.Plus, NumberParsingState.Exponent):
                state = .ExponentDigits
                
            case (_, Token.Zero...Token.Nine, NumberParsingState.Initial):
                state = .Whole
                fallthrough
                
            case (_, Token.Zero...Token.Nine, NumberParsingState.Whole):
                number = number * 10 + Double(codeUnit - Token.Zero)
                
            case (_, Token.Zero...Token.Nine, NumberParsingState.Decimal):
                number = number + depth * Double(codeUnit - Token.Zero)
                depth /= 10
                
            case (_, Token.Zero...Token.Nine, NumberParsingState.Exponent):
                state = .ExponentDigits
                fallthrough
                
            case (_, Token.Zero...Token.Nine, NumberParsingState.ExponentDigits):
                exponent = exponent * 10 + Int(codeUnit) - Int(Token.Zero)
                
            case (_, Token.Period, NumberParsingState.Whole):
                state = .Decimal
                
            case (_, Token.e, NumberParsingState.Whole):      state = .Exponent
            case (_, Token.E, NumberParsingState.Whole):      state = .Exponent
            case (_, Token.e, NumberParsingState.Decimal):    state = .Exponent
            case (_, Token.E, NumberParsingState.Decimal):    state = .Exponent
                
            default:
                
                guard codeUnit.isValidTerminator() else { return nil } // unexpected token
                
                return JSON.Number(number: number, numberSign: numberSign, depth: depth, exponent: exponent, exponentSign: exponentSign, parsingState: state)
            }
        }
        
        guard index < data.count else { return nil } // unable to parse array
        
        return JSON.Number(number: number, numberSign: numberSign, depth: depth, exponent: exponent, exponentSign: exponentSign, parsingState: state)
    }
    
    static func parseTrue(data: Data, inout index: Int) -> Bool {
        
        var index = index
        
        for (index; index < data.count; index++) {
            
            let codeUnit = data[index]
            
            switch (index, codeUnit) {
                
            case (0, Token.t): continue
            case (1, Token.r): continue
            case (2, Token.u): continue
            case (3, Token.e): continue
            case (4, _):
                
                guard codeUnit.isValidTerminator()
                    else { return false }
                
                return true
                
            default: return false
            }
        }
        
        guard index < data.count else { return false }
        
        return true
    }
    
    static func parseFalse(data: Data, inout index: Int) -> Bool {
        
        var index = index
        
        for (index; index < data.count; index++) {
            
            let codeUnit = data[index]
            
            switch (index, codeUnit) {
                
            case (0, Token.f): continue
            case (1, Token.a): continue
            case (2, Token.l): continue
            case (3, Token.s): continue
            case (4, Token.e): continue
            case (5, _):
                
                guard codeUnit.isValidTerminator()
                    else { return false }
                
                return true
                
            default: return false
            }
        }
        
        guard index < data.count else { return false }
        
        return true
    }
    
    static func parseNull(data: Data, inout index: Int) -> Bool {
        
        var index = index
        
        for (index; index < data.count; index++) {
            
            let codeUnit = data[index]
            
            switch (index, codeUnit) {
                
            case (0, Token.n): continue
            case (1, Token.u): continue
            case (2, Token.l): continue
            case (3, Token.l): continue
            case (4, _):
                
                guard codeUnit.isValidTerminator()
                    else { return false }
                
                return true
                
            default: return false
            }
        }
        
        guard index < data.count else { return false }
        
        return true
    }
    
    private static func parseHexDigit(digit: UInt8) -> Int? {
        if Token.Zero <= digit && digit <= Token.Nine {
            return Int(digit) - Int(Token.Zero)
        } else if Token.a <= digit && digit <= Token.f {
            return 10 + Int(digit) - Int(Token.a)
        } else if Token.A <= digit && digit <= Token.F {
            return 10 + Int(digit) - Int(Token.A)
        } else {
            return nil
        }
    }
    
    static private func parseString(data: Data, inout index: Int, quote: Byte) -> String? {
        
        var stringBytes = Data()
        
        for (index; index < data.count; index++) {
            
            let codeUnit = data[index]
            
            switch (index, codeUnit) {
            
            // Beginning
            case (0, quote): continue
            
            // End
            case (_, quote):
                
                index++ // eat the quote
                
                stringBytes.append(0)
                
                let pointer = UnsafePointer<CChar>(stringBytes)
                
                guard let string = String.fromCString(pointer) else { return nil }
                
                return string
                
            case (_, Token.Backslash):
                
                guard index < data.count else { return nil }
                
                index++
                
                let nextByte: Byte = data[index]
                
                switch nextByte {
                    
                case Token.Backslash:       stringBytes.append(Token.Backslash)
                    
                case Token.Forwardslash:    stringBytes.append(Token.Forwardslash)
                    
                case quote:                 stringBytes.append(Token.DoubleQuote)
                    
                case Token.n:               stringBytes.append(Token.Linefeed)
                    
                case Token.b:               stringBytes.append(Token.Backspace)
                    
                case Token.f:               stringBytes.append(Token.Formfeed)
                    
                case Token.r:               stringBytes.append(Token.CarriageReturn)
                    
                case Token.t:               stringBytes.append(Token.HorizontalTab)
                    
                case Token.u:
                    
                    guard index + 4 < data.count else { return nil }
                    
                    let c1 = data[index + 1]
                    let c2 = data[index + 2]
                    let c3 = data[index + 3]
                    let c4 = data[index + 4]
                    
                    index = index + 4
                    
                    guard let value1 = parseHexDigit(c1) else { return nil } // Invalid unicode escape sequence
                    guard let value2 = parseHexDigit(c2) else { return nil }
                    guard let value3 = parseHexDigit(c3) else { return nil }
                    guard let value4 = parseHexDigit(c4) else { return nil }
                    
                    let codepoint = (value1 << 12) | (value2 << 8) | (value3 << 4) | value4
                    
                    let character = String(UnicodeScalar(codepoint))
                    
                    let escapeBytes: Data = character.utf8.map({ (codeUnit: UTF8.CodeUnit) -> Byte in
                        return codeUnit as Byte
                    })
                    
                    stringBytes.extend(escapeBytes)
                    
                default: return nil
                
                }
                
            default: stringBytes.append(codeUnit)
            }
        }
            
        return nil
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
        
        // These are no longer possible to be hit... does it matter???
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

private extension JSON.Number {
    
    init(number: DoubleValue = 0.0,
        numberSign: DoubleValue = 1.0,
        depth: DoubleValue = 0.1,
        exponent: Int = 0,
        exponentSign: Int = 1,
        parsingState state: JSON.NumberParsingState) {
            
            typealias JSONNumber = JSON.Number
        
            switch state {
                
            case .Initial: fatalError("Create number shouldn't be called with an initial state for JSON number parsing")
                
            case .Whole:
                
                let value = Int(number * numberSign)
                
                self = JSONNumber.Integer(value)
                
            case .Decimal:
                
                let value = number * numberSign
                
                self = JSONNumber.Double(value)
                
            case .Exponent, .ExponentDigits:
                
                let doubleValue = JSONNumber.exp(number, exponent * exponentSign) * numberSign
                
                // TODO: Decimal JSON number parse
                
                self = JSONNumber.Double(doubleValue)
            }
    }
    
    static func exp(number: DoubleValue, _ exp: Int) -> DoubleValue {
        return exp < 0 ?
            (0 ..< abs(exp)).reduce(number, combine: { x, _ in x / 10 }) :
            (0 ..< exp).reduce(number, combine: { x, _ in x * 10 })
    }
}


