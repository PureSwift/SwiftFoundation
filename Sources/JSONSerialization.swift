//
//  JSONSerialization.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//
// Serialization from https://github.com/tyrone-sudeium/JSONCore

// MARK: - Serialization Extensions

public extension JSON.Value {
    
    /// Parses ```JSON``` from a string.
    init(string: Swift.String) throws {
        
        let parser = JSONParser(data: string.unicodeScalars)
        
        self = try parser.parse()
    }
    
    func toString(prettyPrint: Bool = false) throws -> Swift.String {
        
        let serializer = JSONSerializer(value: self, prettyPrint: prettyPrint)
        
        return try serializer.serialize()
    }
}

// MARK: - Error

public extension JSON {
    
    /// Errors raised while parsing JSON data.
    public enum ParseError: ErrorType {
        /// Some unknown error, usually indicates something not yet implemented.
        case Unknown
        /// Input data was either empty or contained only whitespace.
        case EmptyInput
        /// Some character that violates the strict JSON grammar was found.
        case UnexpectedCharacter(lineNumber: UInt, characterNumber: UInt)
        /// A JSON string was opened but never closed.
        case UnterminatedString
        /// Any unicode parsing errors will result in this error. Currently unused.
        case InvalidUnicode
        /// A keyword, like `null`, `true`, or `false` was expected but something else was in the input.
        case UnexpectedKeyword(lineNumber: UInt, characterNumber: UInt)
        /// Encountered a JSON number that couldn't be losslessly stored in a `Double` or `Int64`.
        /// Usually the number is too large or too small.
        case InvalidNumber(lineNumber: UInt, characterNumber: UInt)
        /// End of file reached, not always an actual error.
        case EndOfFile
    }
}

public extension JSON {
    
    /// Errors raised while serializing to a JSON string
    public enum SerializeError: ErrorType {
        /// Some unknown error, usually indicates something not yet implemented.
        case Unknown
        /// A number not supported by the JSON spec was encountered, like infinity or NaN.
        case InvalidNumber
    }
}

// MARK: - Private

extension JSON.ParseError: CustomStringConvertible {
    /// Returns a `String` version of the error which can be logged.
    /// Not currently localized.
    public var description: String {
        switch self {
        case .Unknown:
            return "Unknown error"
        case .EmptyInput:
            return "Empty input"
        case .UnexpectedCharacter(let lineNumber, let charNum):
            return "Unexpected character at \(lineNumber):\(charNum)"
        case .UnterminatedString:
            return "Unterminated string"
        case .InvalidUnicode:
            return "Invalid unicode"
        case .UnexpectedKeyword(let lineNumber, let characterNumber):
            return "Unexpected keyword at \(lineNumber):\(characterNumber)"
        case .EndOfFile:
            return "Unexpected end of file"
        case .InvalidNumber:
            return "Invalid number"
        }
    }
}

extension JSON.ParseError: Equatable {}

public func ==(lhs: JSON.ParseError, rhs: JSON.ParseError) -> Bool {
    switch (lhs, rhs) {
    case (.Unknown, .Unknown):
        return true
    case (.EmptyInput, .EmptyInput):
        return true
    case (let .UnexpectedCharacter(ll, lc), let .UnexpectedCharacter(rl, rc)):
        return ll == rl && lc == rc
    case (.UnterminatedString, .UnterminatedString):
        return true
    case (.InvalidUnicode, .InvalidUnicode):
        return true
    case (let .UnexpectedKeyword(ll, lc), let .UnexpectedKeyword(rl, rc)):
        return ll == rl && lc == rc
    case (.EndOfFile, .EndOfFile):
        return true
    default:
        return false
    }
}

// MARK:- Parser

// The structure of this parser is inspired by the great (and slightly insane) NextiveJson parser:
// https://github.com/nextive/NextiveJson

/**
Turns a String represented as a collection of Unicode scalars into a nested graph
of `JSONValue`s. This is a strict parser implementing [ECMA-404](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf).
Being strict, it doesn't support common JSON extensions such as comments.
*/
private class JSONParser {
    /**
     A shortcut for creating a `JSONParser` and having it parse the given data.
     This is a blocking operation, and will block the calling thread until parsing
     finishes or throws an error.
     - Parameter data: The Unicode scalars representing the input JSON data.
     - Returns: The root `JSONValue` node from the input data.
     - Throws: A `JSON.ParseError` if something failed during parsing.
     */
    class func parseData(data: String.UnicodeScalarView) throws -> JSONValue {
        let parser = JSONParser(data: data)
        return try parser.parse()
    }
    
    /**
     Designated initializer for `JSONParser`, which requires an input Unicode scalar
     collection.
     - Parameter data: The Unicode scalars representing the input JSON data.
     */
    init(data: String.UnicodeScalarView) {
        generator = data.generate()
        self.data = data
    }
    
    /**
     Starts parsing the data. This is a blocking operation, and will block the
     calling thread until parsing finishes or throws an error.
     - Returns: The root `JSONValue` node from the input data.
     - Throws: A `JSON.ParseError` if something failed during parsing.
     */
    func parse() throws -> JSONValue {
        do {
            try nextScalar()
            let value = try nextValue()
            do {
                try nextScalar()
                let v = scalar.value
                if v == 0x0009 || v == 0x000A || v == 0x000D || v == 0x0020 {
                    // Skip to EOF or the next token
                    try skipToNextToken()
                    // If we get this far some token was found ...
                    throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
                } else {
                    // There's some weird character at the end of the file...
                    throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
                }
            } catch JSON.ParseError.EndOfFile {
                return value
            }
        } catch JSON.ParseError.EndOfFile {
            throw JSON.ParseError.EmptyInput
        }
    }
    
    // MARK: - Internals: Properties
    
    var generator: String.UnicodeScalarView.Generator
    let data: String.UnicodeScalarView
    var scalar: UnicodeScalar!
    var lineNumber: UInt = 0
    var charNumber: UInt = 0
    
    var crlfHack = false
    
}

// MARK:- Serializer

/**
Turns a nested graph of `JSONValue`s into a Swift `String`. This produces JSON data that
strictly conforms to [ECMA-404](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf). It can optionally pretty-print the output for debugging, but this comes with a non-negligible performance cost.
*/

// TODO: Implement the pretty printer from SDJSONPrettyPrint. I've already written a
// JSON serializer that produces decent output before so I should really reuse its
// logic.
private class JSONSerializer {
    /// Whether this serializer will pretty print output or not.
    let prettyPrint: Bool
    
    /**
     Designated initializer for `JSONSerializer`, which requires an input `JSONValue`.
     - Parameter value: The `JSONValue` to convert to a `String`.
     - Parameter prettyPrint: Whether to print superfluous newlines and spaces to
     make the output easier to read. Has a non-negligible performance cost. Defaults
     to `false`.
     */
    init(value: JSONValue, prettyPrint: Bool = false) {
        self.prettyPrint = prettyPrint
        self.rootValue = value
    }
    
    /**
     Shortcut for creating a `JSONSerializer` and having it serialize the given
     value.
     - Parameter value: The `JSONValue` to convert to a `String`.
     - Parameter prettyPrint: Whether to print superfluous newlines and spaces to
     make the output easier to read. Has a non-negligible performance cost. Defaults
     to `false`.
     - Returns: The serialized value as a `String`.
     - Throws: A `JSON.SerializeError` if something failed during serialization.
     */
    class func serializeValue(value: JSON.Value, prettyPrint: Bool = false) throws -> String {
        let serializer = JSONSerializer(value: value, prettyPrint: prettyPrint)
        return try serializer.serialize()
    }
    
    /**
     Serializes the value passed during initialization.
     - Returns: The serialized value as a `String`.
     - Throws: A `JSON.SerializeError` if something failed during serialization.
     */
    func serialize() throws -> String {
        try serializeValue(rootValue)
        return output
    }
    
    // MARK: Internals: Properties
    let rootValue: JSONValue
    var output: String = ""
}

// MARK: JSONParser Internals
extension JSONParser {
    // MARK: - Enumerating the scalar collection
    func nextScalar() throws {
        if let sc = generator.next() {
            scalar = sc
            charNumber = charNumber + 1
            if crlfHack == true && sc != lineFeed {
                crlfHack = false
            }
        } else {
            throw JSON.ParseError.EndOfFile
        }
    }
    
    func skipToNextToken() throws {
        var v = scalar.value
        if v != 0x0009 && v != 0x000A && v != 0x000D && v != 0x0020 {
            throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
        
        while v == 0x0009 || v == 0x000A || v == 0x000D || v == 0x0020 {
            if scalar == carriageReturn || scalar == lineFeed {
                if crlfHack == true && scalar == lineFeed {
                    crlfHack = false
                    charNumber = 0
                } else {
                    if (scalar == carriageReturn) {
                        crlfHack = true
                    }
                    lineNumber = lineNumber + 1
                    charNumber = 0
                }
            }
            try nextScalar()
            v = scalar.value
        }
    }
    
    func nextScalars(count: UInt) throws -> [UnicodeScalar] {
        var values = [UnicodeScalar]()
        values.reserveCapacity(Int(count))
        for _ in 0..<count {
            try nextScalar()
            values.append(scalar)
        }
        return values
    }
    
    // MARK: - Parse loop
    func nextValue() throws -> JSONValue {
        let v = scalar.value
        if v == 0x0009 || v == 0x000A || v == 0x000D || v == 0x0020 {
            try skipToNextToken()
        }
        switch scalar {
        case leftCurlyBracket:
            return try nextObject()
        case leftSquareBracket:
            return try nextArray()
        case quotationMark:
            return try nextString()
        case trueToken[0], falseToken[0]:
            return try nextBool()
        case nullToken[0]:
            return try nextNull()
        case "0".unicodeScalars.first!..."9".unicodeScalars.first!,negativeScalar,decimalScalar:
            return try nextNumber()
        default:
            throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
    }
    
    // MARK: - Parse a specific, expected type
    func nextObject() throws -> JSON.Value {
        if scalar != leftCurlyBracket {
            throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
        var dictBuilder = [String : JSONValue]()
        try nextScalar()
        if scalar == rightCurlyBracket {
            // Empty object
            return .Object(dictBuilder)
        }
        outerLoop: repeat {
            var v = scalar.value
            if v == 0x0009 || v == 0x000A || v == 0x000D || v == 0x0020 {
                try skipToNextToken()
            }
            let jsonString = try nextString()
            try nextScalar() // Skip the quotation character
            v = scalar.value
            if v == 0x0009 || v == 0x000A || v == 0x000D || v == 0x0020 {
                try skipToNextToken()
            }
            if scalar != colon {
                throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
            }
            try nextScalar() // Skip the ':'
            let value = try nextValue()
            switch value {
                // Skip the closing character for all values except number, which doesn't have one
            case .Number:
                break
            default:
                try nextScalar()
            }
            v = scalar.value
            if v == 0x0009 || v == 0x000A || v == 0x000D || v == 0x0020 {
                try skipToNextToken()
            }
            let key = jsonString.rawValue as! String // We're pretty confident it's a string since we called nextString() above
            dictBuilder[key] = value
            switch scalar {
            case rightCurlyBracket:
                break outerLoop
            case comma:
                try nextScalar()
            default:
                throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
            }
            
        } while true
        return .Object(dictBuilder)
    }
    
    func nextArray() throws -> JSON.Value {
        if scalar != leftSquareBracket {
            throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
        var arrBuilder = [JSONValue]()
        try nextScalar()
        if scalar == rightSquareBracket {
            // Empty array
            return JSONValue.Array(arrBuilder)
        }
        outerLoop: repeat {
            let value = try nextValue()
            arrBuilder.append(value)
            switch value {
                // Skip the closing character for all values except number, which doesn't have one
            case .Number:
                break
            default:
                try nextScalar()
            }
            let v = scalar.value
            if v == 0x0009 || v == 0x000A || v == 0x000D || v == 0x0020 {
                try skipToNextToken()
            }
            switch scalar {
            case rightSquareBracket:
                break outerLoop
            case comma:
                try nextScalar()
            default:
                throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
            }
        } while true
        
        return JSONValue.Array(arrBuilder)
    }
    
    func nextString() throws -> JSONValue {
        if scalar != quotationMark {
            throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
        try nextScalar() // Skip pas the quotation character
        var strBuilder = ""
        var escaping = false
        outerLoop: repeat {
            // First we should deal with the escape character and the terminating quote
            switch scalar {
            case reverseSolidus:
                // Escape character
                if escaping {
                    // Escaping the escape char
                    strBuilder.append(reverseSolidus)
                }
                escaping = !escaping
                try nextScalar()
            case quotationMark:
                if escaping {
                    strBuilder.append(quotationMark)
                    escaping = false
                    try nextScalar()
                } else {
                    break outerLoop
                }
            default:
                // Now the rest
                if escaping {
                    // Handle all the different escape characters
                    if let s = escapeMap[scalar] {
                        strBuilder.append(s)
                        try nextScalar()
                    } else if scalar == "u".unicodeScalars.first! {
                        let escapedUnicodeValue = try nextUnicodeEscape()
                        strBuilder.append(UnicodeScalar(escapedUnicodeValue))
                        try nextScalar()
                    }
                    escaping = false
                } else {
                    // Simple append
                    strBuilder.append(scalar)
                    try nextScalar()
                }
            }
        } while true
        return .String(strBuilder)
    }
    
    func nextUnicodeEscape() throws -> UInt32 {
        if scalar != "u".unicodeScalars.first! {
            throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
        var readScalar = UInt32(0)
        for _ in 0...3 {
            readScalar = readScalar * 16
            try nextScalar()
            if ("0".unicodeScalars.first!..."9".unicodeScalars.first!).contains(scalar) {
                readScalar = readScalar + UInt32(scalar.value - "0".unicodeScalars.first!.value)
            } else if ("a".unicodeScalars.first!..."f".unicodeScalars.first!).contains(scalar) {
                let aScalarVal = "a".unicodeScalars.first!.value
                let hexVal = scalar.value - aScalarVal
                let hexScalarVal = hexVal + 10
                readScalar = readScalar + hexScalarVal
            } else if ("A".unicodeScalars.first!..."F".unicodeScalars.first!).contains(scalar) {
                let aScalarVal = "A".unicodeScalars.first!.value
                let hexVal = scalar.value - aScalarVal
                let hexScalarVal = hexVal + 10
                readScalar = readScalar + hexScalarVal
            } else {
                throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
            }
        }
        if readScalar >= 0xD800 && readScalar <= 0xDBFF {
            // UTF-16 surrogate pair
            // The next character MUST be the other half of the surrogate pair
            // Otherwise it's a unicode error
            do {
                try nextScalar()
                if scalar != reverseSolidus {
                    throw JSON.ParseError.InvalidUnicode
                }
                try nextScalar()
                let secondScalar = try nextUnicodeEscape()
                if secondScalar < 0xDC00 || secondScalar > 0xDFFF {
                    throw JSON.ParseError.InvalidUnicode
                }
                let actualScalar = (readScalar - 0xD800) * 0x400 + (secondScalar - 0xDC00) + 0x10000
                return actualScalar
            } catch JSON.ParseError.UnexpectedCharacter {
                throw JSON.ParseError.InvalidUnicode
            }
        }
        return readScalar
    }
    
    func nextNumber() throws -> JSONValue {
        var isNegative = false
        var hasDecimal = false
        var hasDigits = false
        var hasExponent = false
        var positiveExponent = false
        var exponent = 0
        var integer: UInt64 = 0
        var decimal: Int64 = 0
        var divisor: Double = 10
        let lineNumAtStart = lineNumber
        let charNumAtStart = charNumber
        
        do {
            outerLoop: repeat {
                switch scalar {
                case "0".unicodeScalars.first!..."9".unicodeScalars.first!:
                    hasDigits = true
                    if hasDecimal {
                        decimal *= 10
                        decimal += Int64(scalar.value - zeroScalar.value)
                        divisor *= 10
                    } else {
                        integer *= 10
                        integer += UInt64(scalar.value - zeroScalar.value)
                    }
                    try nextScalar()
                case negativeScalar:
                    if hasDigits || hasDecimal || hasDigits || isNegative {
                        throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
                    } else {
                        isNegative = true
                    }
                    try nextScalar()
                case decimalScalar:
                    if hasDecimal {
                        throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
                    } else {
                        hasDecimal = true
                    }
                    try nextScalar()
                case "e".unicodeScalars.first!,"E".unicodeScalars.first!:
                    if hasExponent {
                        throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
                    } else {
                        hasExponent = true
                    }
                    try nextScalar()
                    switch scalar {
                    case "0".unicodeScalars.first!..."9".unicodeScalars.first!:
                        positiveExponent = true
                    case plusScalar:
                        positiveExponent = true
                        try nextScalar()
                    case negativeScalar:
                        positiveExponent = false
                        try nextScalar()
                    default:
                        throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
                    }
                    exponentLoop: repeat {
                        if scalar.value >= zeroScalar.value && scalar.value <= "9".unicodeScalars.first!.value {
                            exponent *= 10
                            exponent += Int(scalar.value - zeroScalar.value)
                            try nextScalar()
                        } else {
                            break exponentLoop
                        }
                    } while true
                default:
                    break outerLoop
                }
            } while true
        } catch JSON.ParseError.EndOfFile {
            // This is fine
        }
        
        if !hasDigits {
            throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
        
        let sign = isNegative ? -1 : 1
        if hasDecimal || hasExponent {
            divisor /= 10
            var number = Double(sign) * (Double(integer) + (Double(decimal) / divisor))
            if hasExponent {
                if positiveExponent {
                    for _ in 1...exponent {
                        number *= Double(10)
                    }
                } else {
                    for _ in 1...exponent {
                        number /= Double(10)
                    }
                }
            }
            return .Number(.Double(number))
        } else {
            var number: Int64
            if isNegative {
                if integer > UInt64(Int64.max) + 1 {
                    throw JSON.ParseError.InvalidNumber(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
                } else if integer == UInt64(Int64.max) + 1 {
                    number = Int64.min
                } else {
                    number = Int64(integer) * -1
                }
            } else {
                if integer > UInt64(Int64.max) {
                    throw JSON.ParseError.InvalidNumber(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
                } else {
                    number = Int64(integer)
                }
            }
            return .Number(.Integer(number))
        }
    }
    
    func nextBool() throws -> JSONValue {
        var expectedWord: [UnicodeScalar]
        var expectedBool: Bool
        let lineNumAtStart = lineNumber
        let charNumAtStart = charNumber
        if scalar == trueToken[0] {
            expectedWord = trueToken
            expectedBool = true
        } else if scalar == falseToken[0] {
            expectedWord = falseToken
            expectedBool = false
        } else {
            throw JSON.ParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
        do {
            let word = try [scalar] + nextScalars(UInt(expectedWord.count - 1))
            if word != expectedWord {
                throw JSON.ParseError.UnexpectedKeyword(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
            }
        } catch JSON.ParseError.EndOfFile {
            throw JSON.ParseError.UnexpectedKeyword(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
        }
        return .Number(.Boolean(expectedBool))
    }
    
    func nextNull() throws -> JSONValue {
        let word = try [scalar] + nextScalars(3)
        if word != nullToken {
            throw JSON.ParseError.UnexpectedKeyword(lineNumber: lineNumber, characterNumber: charNumber-4)
        }
        return .Null
    }
}

// MARK: JSONSerializer Internals
extension JSONSerializer {
    
    func serializeValue(value: JSONValue) throws {
        switch value {
        case .Number(let nt):
            switch nt {
            case .Double(let f):
                try serializeDouble(f)
            case .Integer(let i):
                serializeInt64(i)
            case .Boolean(let b):
                serializeBool(b)
            }
        case .Null:
            serializeNull()
        case .String(let s):
            serializeString(s)
        case .Object(let obj):
            try serializeObject(obj)
        case .Array(let a):
            try serializeArray(a)
        }
    }
    
    func serializeObject(obj: [String : JSONValue]) throws {
        output.append(leftCurlyBracket)
        var i = 0
        for (key, value) in obj {
            serializeString(key)
            output.append(colon)
            try serializeValue(value)
            i++
            if i != obj.count {
                output.append(comma)
            }
        }
        output.append(rightCurlyBracket)
    }
    
    func serializeArray(arr: [JSONValue]) throws {
        output.append(leftSquareBracket)
        var i = 0
        for val in arr {
            try serializeValue(val)
            i++
            if i != arr.count {
                output.append(comma)
            }
        }
        output.append(rightSquareBracket)
    }
    
    func serializeString(str: String) {
        output.append(quotationMark)
        var generator = str.unicodeScalars.generate()
        while let scalar = generator.next() {
            switch scalar.value {
            case solidus.value:
                fallthrough
            case 0x0000...0x001F:
                output.append(reverseSolidus)
                switch scalar {
                case tabCharacter:
                    output.appendContentsOf("t")
                case carriageReturn:
                    output.appendContentsOf("r")
                case lineFeed:
                    output.appendContentsOf("n")
                case quotationMark:
                    output.append(quotationMark)
                case backspace:
                    output.appendContentsOf("b")
                case solidus:
                    output.append(solidus)
                default:
                    output.appendContentsOf("u")
                    output.append(hexScalars[Int(scalar.value) & 0xF000 >> 12])
                    output.append(hexScalars[Int(scalar.value) & 0x0F00 >> 8])
                    output.append(hexScalars[Int(scalar.value) & 0x00F0 >> 4])
                    output.append(hexScalars[Int(scalar.value) & 0x000F >> 0])
                }
            default:
                output.append(scalar)
            }
        }
        output.append(quotationMark)
    }
    
    func serializeDouble(f: Double) throws {
        if f.isNaN || f.isInfinite {
            throw JSON.SerializeError.InvalidNumber
        } else {
            // TODO: Is CustomStringConvertible for number types affected by locale?
            // TODO: Is CustomStringConvertible for Double fast?
            output.appendContentsOf(f.description)
        }
    }
    
    func serializeInt64(i: Int64) {
        // TODO: Is CustomStringConvertible for number types affected by locale?
        output.appendContentsOf(i.description)
    }
    
    func serializeBool(bool: Bool) {
        switch bool {
        case true:
            output.appendContentsOf("true")
        case false:
            output.appendContentsOf("false")
        }
    }
    
    func serializeNull() {
        output.appendContentsOf("null")
    }
}


private let leftSquareBracket = UnicodeScalar(0x005b)
private let leftCurlyBracket = UnicodeScalar(0x007b)
private let rightSquareBracket = UnicodeScalar(0x005d)
private let rightCurlyBracket = UnicodeScalar(0x007d)
private let colon = UnicodeScalar(0x003A)
private let comma = UnicodeScalar(0x002C)
private let zeroScalar = "0".unicodeScalars.first!
private let negativeScalar = "-".unicodeScalars.first!
private let plusScalar = "+".unicodeScalars.first!
private let decimalScalar = ".".unicodeScalars.first!
private let quotationMark = UnicodeScalar(0x0022)
private let carriageReturn = UnicodeScalar(0x000D)
private let lineFeed = UnicodeScalar(0x000A)

// String escapes
private let reverseSolidus = UnicodeScalar(0x005C)
private let solidus = UnicodeScalar(0x002F)
private let backspace = UnicodeScalar(0x0008)
private let formFeed = UnicodeScalar(0x000C)
private let tabCharacter = UnicodeScalar(0x0009)

private let trueToken = [UnicodeScalar]("true".unicodeScalars)
private let falseToken = [UnicodeScalar]("false".unicodeScalars)
private let nullToken = [UnicodeScalar]("null".unicodeScalars)

private let escapeMap = [
    "/".unicodeScalars.first!: solidus,
    "b".unicodeScalars.first!: backspace,
    "f".unicodeScalars.first!: formFeed,
    "n".unicodeScalars.first!: lineFeed,
    "r".unicodeScalars.first!: carriageReturn,
    "t".unicodeScalars.first!: tabCharacter
]

private let hexScalars = [
    "0".unicodeScalars.first!,
    "1".unicodeScalars.first!,
    "2".unicodeScalars.first!,
    "3".unicodeScalars.first!,
    "4".unicodeScalars.first!,
    "5".unicodeScalars.first!,
    "6".unicodeScalars.first!,
    "7".unicodeScalars.first!,
    "8".unicodeScalars.first!,
    "9".unicodeScalars.first!,
    "a".unicodeScalars.first!,
    "b".unicodeScalars.first!,
    "c".unicodeScalars.first!,
    "d".unicodeScalars.first!,
    "e".unicodeScalars.first!,
    "f".unicodeScalars.first!
]