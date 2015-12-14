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
        
        let coreValue = try parser.parse()
        
        self = coreValue.toJSON()
    }
    
    func toString(prettyPrint: Bool = false) throws -> Swift.String {
        
        let coreValue = JSONCoreValue(JSONValue: self)
        
        let serializer = JSONSerializer(value: coreValue, prettyPrint: prettyPrint)
        
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

// MARK: - JSONCore

// Made everything in JSONCore that was public, into private
// Renamed JSONValue to JSONCoreValue, JSONObject to JSONCoreObject
// Deleted Errors

internal typealias JSONParseError = JSON.ParseError
internal typealias JSONSerializeError = JSON.SerializeError

internal extension JSONCoreValue {
    
    init(JSONValue: JSON.Value) {
        
        switch JSONValue {
            
        case .Null: self = .JSONNull
            
        case .String(let value): self = .JSONString(value)
                        
        case .Array(let arrayValue):
            
            let convertedArray = arrayValue.map { (JSONValue) in return JSONCoreValue(JSONValue: JSONValue) }
            
            self = .JSONArray(convertedArray)
            
        case .Object(let objectValue):
            
            var coreObject = JSONCoreObject()
            
            for (key, value) in objectValue {
                
                let coreValue = JSONCoreValue(JSONValue: value)
                
                coreObject[key] = coreValue
            }
            
            self = .JSONObject(coreObject)
            
        case .Number(let number):
            
            switch number {
                
            case .Integer(let value): self = .JSONNumber(.JSONIntegral(Int64(value)))
            case .Double(let value): self = .JSONNumber(.JSONFractional(value))
            case .Boolean(let value): self = .JSONBool(value)
            }
        }
    }
    
    func toJSON() -> JSONValue {
        
        switch self {
            
        case .JSONNull: return .Null
        
        case .JSONString(let value): return .String(value)
            
        case .JSONBool(let value): return .Number(.Boolean(value))
            
        case .JSONNumber(let numberValue):
            
            switch numberValue {
                
            case .JSONIntegral(let value): return .Number(.Integer(Int(value)))
            case .JSONFractional(let value): return .Number(.Double(value))
                
            }
        
        case .JSONArray(let coreArray):
            
            // map doesnt work for some reason
            
            var jsonArray = JSON.Array()
            
            for coreValue in coreArray {
                
                jsonArray.append(coreValue.toJSON())
            }
            
            return .Array(jsonArray)
            
        case .JSONObject(let coreObject):
            
            var jsonObject = JSON.Object()
            
            for (key, coreValue) in coreObject {
                
                let jsonValue = coreValue.toJSON()
                
                jsonObject[key] = jsonValue
            }
            
            return .Object(jsonObject)
        }
    }
}

