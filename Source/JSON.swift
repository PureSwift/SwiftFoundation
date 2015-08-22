//
//  JSON.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// [JavaScript Object Notation](json.org)
public struct JSON {
    
    /// JSON value type.
    /// Guarenteed to be valid JSON if root value is array or object.
    public enum Value: RawRepresentable {
        
        case Null
        
        /// JSON value is a String Value
        case String(StringValue)
        
        /// JSON value is a Number Value (specific subtypes)
        case Number(JSON.Number)
        
        /// JSON value is an Array of other JSON values
        case Array(JSONArray)
        
        /// JSON value a JSON object
        case Object(JSONObject)
        
        // MARK: RawRepresentable
        
        public var rawValue: Any {
            
            switch self {
                
            case .Null: return Null
                
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
        
        public init?(rawValue: Any) {
            
            guard (rawValue as? NullValue) == nil else {
                
                self = .Null
                return
            }
            
            if let string = rawValue as? StringValue {
                
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
            
            if let rawDictionary = rawValue as? [StringValue: Any] {
                
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
    
    public enum Number: RawRepresentable {
        
        case Boolean(Bool)
        
        case Integer(Int)
        
        case Double(DoubleValue)
        
        // MARK: RawRepresentable
        
        public var rawValue: Any {
            
            switch self {
            case .Boolean(let value): return value
            case .Integer(let value): return value
            case .Double(let value):  return value
            }
        }
        
        public init?(rawValue: Any) {
            
            if let value = rawValue as? Bool            { self = .Boolean(value) }
            if let value = rawValue as? Int             { self = .Integer(value) }
            if let value = rawValue as? DoubleValue     { self = .Double(value)  }
            
            return nil
        }
    }
}

public protocol JSONConvertible {
    
    /// Decodes the reciever from JSON.
    init?(JSONValue: JSON.Value)
    
    /// Encodes the reciever into JSON.
    func toJSON() -> JSON.Value
}

// Typealiases due to compiler error

public typealias JSONValue = JSON.Value

public typealias JSONArray = [JSON.Value]

public typealias JSONObject = [String: JSON.Value]

public typealias StringValue = String

public typealias FloatValue = Float

public typealias DoubleValue = Double

public typealias DecimalValue = Decimal

public typealias NullValue = Null

