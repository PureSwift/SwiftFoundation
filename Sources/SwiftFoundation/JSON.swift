//
//  JSON.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// [JavaScript Object Notation](json.org)
public struct JSON {
    
    public typealias Array = [JSON.Value]
    
    public typealias Object = [String: JSON.Value]
    
    /// JSON value type.
    /// Guarenteed to be valid JSON if root value is array or object.
    public enum Value: RawRepresentable, Equatable, CustomStringConvertible {
        
        case Null
        
        /// JSON value is a String Value
        case String(StringValue)
        
        /// JSON value is a Number Value (specific subtypes)
        case Number(JSON.Number)
        
        /// JSON value is an Array of other JSON values
        case Array(JSONArray)
        
        /// JSON value a JSON object
        case Object(JSONObject)
        
        // MARK: - Extract Values
        
        public var arrayValue: JSON.Array? {
            
            switch self {
                
            case let .Array(value): return value
                
            default: return nil
            }
        }
        
        public var objectValue: JSON.Object? {
            
            switch self {
                
            case let .Object(value): return value
                
            default: return nil
            }
        }
    }
    
    // MARK: - JSON Number
    
    public enum Number: RawRepresentable, Equatable, CustomStringConvertible {
        
        case Boolean(Bool)
        
        case Integer(Int)
        
        case Double(DoubleValue)
    }
}

// MARK: - RawRepresentable

public extension JSON.Value {
    
    var rawValue: Any {
        
        switch self {
            
        case .Null: return SwiftFoundation.Null()
            
        case .String(let string): return string
            
        case .Number(let number): return number.rawValue
            
        case .Array(let array): return array.rawValues
            
        case .Object(let dictionary):
            
            var dictionaryValue = [StringValue: Any](minimumCapacity: dictionary.count)
            
            for (key, value) in dictionary {
                
                dictionaryValue[key] = value.rawValue
            }
            
            return dictionaryValue
        }
    }
    
    init?(rawValue: Any) {
        
        guard (rawValue as? SwiftFoundation.Null) == nil else {
            
            self = .Null
            return
        }
        
        if let string = rawValue as? Swift.String {
            
            self = .String(string)
            return
        }
        
        if let number = JSON.Number(rawValue: rawValue) {
            
            self = .Number(number)
            return
        }
        
        if let rawArray = rawValue as? [Any], let jsonArray: [JSON.Value] = JSON.Value.fromRawValues(rawArray) {
            
            self = .Array(jsonArray)
            return
        }
        
        if let rawDictionary = rawValue as? [Swift.String: Any] {
            
            var jsonObject = [StringValue: JSONValue](minimumCapacity: rawDictionary.count)
            
            for (key, rawValue) in rawDictionary {
                
                guard let jsonValue = JSON.Value(rawValue: rawValue) else { return nil }
                
                jsonObject[key] = jsonValue
            }
            
            self = .Object(jsonObject)
            return
        }
        
        return nil
    }
}

public extension JSON.Number {
    
    public var rawValue: Any {
        
        switch self {
        case .Boolean(let value): return value
        case .Integer(let value): return value
        case .Double(let value):  return value
        }
    }
    
    public init?(rawValue: Any) {
        
        if let value = rawValue as? Bool            { self = .Boolean(value); return }
        if let value = rawValue as? Int             { self = .Integer(value); return }
        if let value = rawValue as? DoubleValue     { self = .Double(value); return  }
        
        return nil
    }
}


// MARK: - CustomStringConvertible

public extension JSON.Value {
    
    public var description: Swift.String {
        
        return "\(rawValue)"
    }
}

public extension JSON.Number {
    
    public var description: String {
        
        return "\(rawValue)"
    }
}

// MARK: Equatable

public func ==(lhs: JSON.Value, rhs: JSON.Value) -> Bool {
    
    switch (lhs, rhs) {
        
    case (.Null, .Null): return true
        
    case let (.String(leftValue), .String(rightValue)): return leftValue == rightValue
        
    case let (.Number(leftValue), .Number(rightValue)): return leftValue == rightValue
        
    case let (.Array(leftValue), .Array(rightValue)): return leftValue == rightValue
        
    case let (.Object(leftValue), .Object(rightValue)): return leftValue == rightValue
        
    default: return false
    }
}

public func ==(lhs: JSON.Number, rhs: JSON.Number) -> Bool {
    
    switch (lhs, rhs) {
        
    case let (.Boolean(leftValue), .Boolean(rightValue)): return leftValue == rightValue
        
    case let (.Integer(leftValue), .Integer(rightValue)): return leftValue == rightValue
        
    case let (.Double(leftValue), .Double(rightValue)): return leftValue == rightValue
        
    default: return false
    }
}

// MARK: - Protocol

/// Type can be converted to JSON.
public protocol JSONEncodable {
    
    /// Encodes the reciever into JSON.
    func toJSON() -> JSON.Value
}

/// Type can be converted from JSON.
public protocol JSONDecodable {
    
    /// Decodes the reciever from JSON.
    init?(JSONValue: JSON.Value)
}

/// Type can be converted from JSON according to parameters.
public protocol JSONParametrizedDecodable {
    
    typealias JSONDecodingParameters
    
    /// Decodes the reciever from JSON according to the specified parameters.
    init?(JSONValue: JSON.Value, parameters: JSONDecodingParameters)
}

// Typealiases due to compiler error

public typealias JSONValue = JSON.Value

public typealias JSONArray = [JSONValue]

public typealias JSONObject = [String: JSONValue]

public typealias StringValue = String

public typealias FloatValue = Float

public typealias DoubleValue = Double

public typealias NullValue = Null

