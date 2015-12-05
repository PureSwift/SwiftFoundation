//
//  JSONCore.swift
//  JSONCore
//
//  Created by Tyrone Trevorrow on 23/10/2015.
//  Copyright © 2015 Tyrone Trevorrow. All rights reserved.
//
//
// JSONCore: A totally native Swift JSON engine
// Does NOT use NSJSONSerialization. In fact, does not require `import Foundation` at all!
//

// MARK: internal API

/// The specific type of Swift dictionary that represents valid JSON objects
internal typealias JSONCoreObject = [String : JSONCoreValue]

// MARK: - JSON Values
/// Numbers from JSON Core are wrapped in this enum to express its two possible
/// storage types.
internal enum JSONNumberType {
    /// Numbers in JSON that can be represented as whole numbers are stored as an `Int64`.
    case JSONIntegral(Int64)
    /// Numbers in JSON that have decimals or exponents are stored as `Double`.
    case JSONFractional(Double)
}

/// Any value that can be expressed in JSON has a representation in `JSONCoreValue`.
internal enum JSONCoreValue {
    /// Representation of JSON's number type.
    case JSONNumber(JSONNumberType)
    /// Representation of a `null` from JSON.
    case JSONNull
    /// Representation of strings from JSON.
    case JSONString(String)
    /// Representation of a JSON object, which is a Dictionary with `String` keys and `JSONCoreValue` values.
    case JSONObject([String:JSONCoreValue])
    /// Representation of `true` and `false` from JSON.
    case JSONBool(Bool)
    /// Representation of a JSON array, which is an array of `JSONCoreValue`s.
    case JSONArray([JSONCoreValue])
    
    /// Returns this enum's associated String value if it is one, `nil` otherwise.
    internal var string: String? {
        get {
            switch self {
            case .JSONString(let s):
                return s
            default:
                return nil
            }
        }
    }
    
    /// Returns this enum's associated Dictionary value if it is one, `nil` otherwise.
    internal var object: [String : JSONCoreValue]? {
        get {
            switch self {
            case .JSONObject(let o):
                return o
            default:
                return nil
            }
        }
    }
    
    /// Returns this enum's associated Bool value if it is one, `nil` otherwise.
    internal var bool: Bool? {
        get {
            switch self {
            case .JSONBool(let b):
                return b
            default:
                return nil
            }
        }
    }
    
    /// Returns this enum's associated Array value if it is one, `nil` otherwise.
    internal var array: [JSONCoreValue]? {
        get {
            switch self {
            case .JSONArray(let a):
                return a
            default:
                return nil
            }
        }
    }
    
    /// Returns this enum's associated Int64 value if it is one, `nil` otherwise.
    internal var int: Int64? {
        get {
            switch self {
            case .JSONNumber(let num):
                switch num {
                case .JSONIntegral(let i):
                    return i
                default:
                    return nil
                }
            default:
                return nil
            }
        }
    }
    
    /// Returns this enum's associated Double value if it is one, `nil` otherwise.
    internal var double: Double? {
        get {
            switch self {
            case .JSONNumber(let num):
                switch num {
                case .JSONFractional(let f):
                    return f
                default:
                    return nil
                }
            default:
                return nil
            }
        }
    }
}

extension JSONNumberType : Equatable {}

internal func ==(lhs: JSONNumberType, rhs: JSONNumberType) -> Bool {
    switch (lhs, rhs) {
    case (let .JSONIntegral(l), let .JSONIntegral(r)):
        return l == r
    case (let .JSONFractional(l), let .JSONFractional(r)):
        return l == r
    default:
        return false
    }
}

extension JSONCoreValue: Equatable {}

internal func ==(lhs: JSONCoreValue, rhs: JSONCoreValue) -> Bool {
    switch (lhs, rhs) {
    case (let .JSONNumber(lnum), let .JSONNumber(rnum)):
        return lnum == rnum
    case (.JSONNull, .JSONNull):
        return true
    case (let .JSONString(l), let .JSONString(r)):
        return l == r
    case (let .JSONObject(l), let .JSONObject(r)):
        return l == r
    case (let .JSONBool(l), let .JSONBool(r)):
        return l == r
    case (let .JSONArray(l), let .JSONArray(r)):
        return l == r
    default:
        return false
    }
}

// MARK:- Parser

// The structure of this parser is inspired by the great (and slightly insane) NextiveJson parser:
// https://github.com/nextive/NextiveJson

/**
Turns a String represented as a collection of Unicode scalars into a nested graph
of `JSONCoreValue`s. This is a strict parser implementing [ECMA-404](http://www.ecma-international.org/internalations/files/ECMA-ST/ECMA-404.pdf).
Being strict, it doesn't support common JSON extensions such as comments.
*/
internal class JSONParser {
    /**
     A shortcut for creating a `JSONParser` and having it parse the given data.
     This is a blocking operation, and will block the calling thread until parsing
     finishes or throws an error.
     - Parameter data: The Unicode scalars representing the input JSON data.
     - Returns: The root `JSONCoreValue` node from the input data.
     - Throws: A `JSONParseError` if something failed during parsing.
     */
    internal class func parseData(data: String.UnicodeScalarView) throws -> JSONCoreValue {
        let parser = JSONParser(data: data)
        return try parser.parse()
    }
    
    /**
     Designated initializer for `JSONParser`, which requires an input Unicode scalar
     collection.
     - Parameter data: The Unicode scalars representing the input JSON data.
     */
    internal init(data: String.UnicodeScalarView) {
        generator = data.generate()
        self.data = data
    }
    
    /**
     Starts parsing the data. This is a blocking operation, and will block the
     calling thread until parsing finishes or throws an error.
     - Returns: The root `JSONCoreValue` node from the input data.
     - Throws: A `JSONParseError` if something failed during parsing.
     */
    internal func parse() throws -> JSONCoreValue {
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
                    throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
                } else {
                    // There's some weird character at the end of the file...
                    throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
                }
            } catch JSONParseError.EndOfFile {
                return value
            }
        } catch JSONParseError.EndOfFile {
            throw JSONParseError.EmptyInput
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
Turns a nested graph of `JSONCoreValue`s into a Swift `String`. This produces JSON data that
strictly conforms to [ECMA-404](http://www.ecma-international.org/internalations/files/ECMA-ST/ECMA-404.pdf). It can optionally pretty-print the output for debugging, but this comes with a non-negligible performance cost.
*/

// TODO: Implement the pretty printer from SDJSONPrettyPrint. I've already written a
// JSON serializer that produces decent output before so I should really reuse its
// logic.
internal class JSONSerializer {
    /// Whether this serializer will pretty print output or not.
    internal let prettyPrint: Bool
    
    /**
     Designated initializer for `JSONSerializer`, which requires an input `JSONCoreValue`.
     - Parameter value: The `JSONCoreValue` to convert to a `String`.
     - Parameter prettyPrint: Whether to print superfluous newlines and spaces to
     make the output easier to read. Has a non-negligible performance cost. Defaults
     to `false`.
     */
    internal init(value: JSONCoreValue, prettyPrint: Bool = false) {
        self.prettyPrint = prettyPrint
        self.rootValue = value
    }
    
    /**
     Shortcut for creating a `JSONSerializer` and having it serialize the given
     value.
     - Parameter value: The `JSONCoreValue` to convert to a `String`.
     - Parameter prettyPrint: Whether to print superfluous newlines and spaces to
     make the output easier to read. Has a non-negligible performance cost. Defaults
     to `false`.
     - Returns: The serialized value as a `String`.
     - Throws: A `JSONSerializeError` if something failed during serialization.
     */
    internal class func serializeValue(value: JSONCoreValue, prettyPrint: Bool = false) throws -> String {
        let serializer = JSONSerializer(value: value, prettyPrint: prettyPrint)
        return try serializer.serialize()
    }
    
    /**
     Serializes the value passed during initialization.
     - Returns: The serialized value as a `String`.
     - Throws: A `JSONSerializeError` if something failed during serialization.
     */
    internal func serialize() throws -> String {
        try serializeValue(rootValue)
        return output
    }
    
    // MARK: Internals: Properties
    let rootValue: JSONCoreValue
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
            throw JSONParseError.EndOfFile
        }
    }
    
    func skipToNextToken() throws {
        var v = scalar.value
        if v != 0x0009 && v != 0x000A && v != 0x000D && v != 0x0020 {
            throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
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
    func nextValue() throws -> JSONCoreValue {
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
            throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
    }
    
    // MARK: - Parse a specific, expected type
    func nextObject() throws -> JSONCoreValue {
        if scalar != leftCurlyBracket {
            throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
        var dictBuilder = [String : JSONCoreValue]()
        try nextScalar()
        if scalar == rightCurlyBracket {
            // Empty object
            return JSONCoreValue.JSONObject(dictBuilder)
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
                throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
            }
            try nextScalar() // Skip the ':'
            let value = try nextValue()
            switch value {
                // Skip the closing character for all values except number, which doesn't have one
            case .JSONNumber:
                break
            default:
                try nextScalar()
            }
            v = scalar.value
            if v == 0x0009 || v == 0x000A || v == 0x000D || v == 0x0020 {
                try skipToNextToken()
            }
            let key = jsonString.string! // We're pretty confident it's a string since we called nextString() above
            dictBuilder[key] = value
            switch scalar {
            case rightCurlyBracket:
                break outerLoop
            case comma:
                try nextScalar()
            default:
                throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
            }
            
        } while true
        return JSONCoreValue.JSONObject(dictBuilder)
    }
    
    func nextArray() throws -> JSONCoreValue {
        if scalar != leftSquareBracket {
            throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
        var arrBuilder = [JSONCoreValue]()
        try nextScalar()
        if scalar == rightSquareBracket {
            // Empty array
            return JSONCoreValue.JSONArray(arrBuilder)
        }
        outerLoop: repeat {
            let value = try nextValue()
            arrBuilder.append(value)
            switch value {
                // Skip the closing character for all values except number, which doesn't have one
            case .JSONNumber:
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
                throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
            }
        } while true
        
        return JSONCoreValue.JSONArray(arrBuilder)
    }
    
    func nextString() throws -> JSONCoreValue {
        if scalar != quotationMark {
            throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
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
        return JSONCoreValue.JSONString(strBuilder)
    }
    
    func nextUnicodeEscape() throws -> UInt32 {
        if scalar != "u".unicodeScalars.first! {
            throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
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
                throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
            }
        }
        if readScalar >= 0xD800 && readScalar <= 0xDBFF {
            // UTF-16 surrogate pair
            // The next character MUST be the other half of the surrogate pair
            // Otherwise it's a unicode error
            do {
                try nextScalar()
                if scalar != reverseSolidus {
                    throw JSONParseError.InvalidUnicode
                }
                try nextScalar()
                let secondScalar = try nextUnicodeEscape()
                if secondScalar < 0xDC00 || secondScalar > 0xDFFF {
                    throw JSONParseError.InvalidUnicode
                }
                let actualScalar = (readScalar - 0xD800) * 0x400 + (secondScalar - 0xDC00) + 0x10000
                return actualScalar
            } catch JSONParseError.UnexpectedCharacter {
                throw JSONParseError.InvalidUnicode
            }
        }
        return readScalar
    }
    
    func nextNumber() throws -> JSONCoreValue {
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
                        throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
                    } else {
                        isNegative = true
                    }
                    try nextScalar()
                case decimalScalar:
                    if hasDecimal {
                        throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
                    } else {
                        hasDecimal = true
                    }
                    try nextScalar()
                case "e".unicodeScalars.first!,"E".unicodeScalars.first!:
                    if hasExponent {
                        throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
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
                        throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
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
        } catch JSONParseError.EndOfFile {
            // This is fine
        }
        
        if !hasDigits {
            throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
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
            return JSONCoreValue.JSONNumber(JSONNumberType.JSONFractional(number))
        } else {
            var number: Int64
            if isNegative {
                if integer > UInt64(Int64.max) + 1 {
                    throw JSONParseError.InvalidNumber(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
                } else if integer == UInt64(Int64.max) + 1 {
                    number = Int64.min
                } else {
                    number = Int64(integer) * -1
                }
            } else {
                if integer > UInt64(Int64.max) {
                    throw JSONParseError.InvalidNumber(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
                } else {
                    number = Int64(integer)
                }
            }
            return JSONCoreValue.JSONNumber(JSONNumberType.JSONIntegral(number))
        }
    }
    
    func nextBool() throws -> JSONCoreValue {
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
            throw JSONParseError.UnexpectedCharacter(lineNumber: lineNumber, characterNumber: charNumber)
        }
        do {
            let word = try [scalar] + nextScalars(UInt(expectedWord.count - 1))
            if word != expectedWord {
                throw JSONParseError.UnexpectedKeyword(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
            }
        } catch JSONParseError.EndOfFile {
            throw JSONParseError.UnexpectedKeyword(lineNumber: lineNumAtStart, characterNumber: charNumAtStart)
        }
        return JSONCoreValue.JSONBool(expectedBool)
    }
    
    func nextNull() throws -> JSONCoreValue {
        let word = try [scalar] + nextScalars(3)
        if word != nullToken {
            throw JSONParseError.UnexpectedKeyword(lineNumber: lineNumber, characterNumber: charNumber-4)
        }
        return JSONCoreValue.JSONNull
    }
}

// MARK: JSONSerializer Internals
extension JSONSerializer {
    
    func serializeValue(value: JSONCoreValue) throws {
        switch value {
        case .JSONNumber(let nt):
            switch nt {
            case .JSONFractional(let f):
                try serializeDouble(f)
            case .JSONIntegral(let i):
                serializeInt64(i)
            }
        case .JSONNull:
            serializeNull()
        case .JSONString(let s):
            serializeString(s)
        case .JSONObject(let obj):
            try serializeObject(obj)
        case .JSONBool(let b):
            serializeBool(b)
        case .JSONArray(let a):
            try serializeArray(a)
        }
    }
    
    func serializeObject(obj: [String : JSONCoreValue]) throws {
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
    
    func serializeArray(arr: [JSONCoreValue]) throws {
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
            throw JSONSerializeError.InvalidNumber
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
