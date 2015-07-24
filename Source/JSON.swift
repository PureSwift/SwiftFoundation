//
//  JSON.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public typealias JSONArray = [JSONValue]

public typealias JSONObject = [String: JSONValue]

public enum JSONValue: RawRepresentable {
    
    case Null
    
    /// JSON value is a String Value
    case String(StringValue)
    
    /// JSON value is a Number Value (specific subtypes)
    case Number(JSONNumber)
    
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
        
        if let number = JSONNumber(rawValue: rawValue) {
            
            self = .Number(number)
            return
        }
        
        if let rawArray = rawValue as? [Any], let jsonArray: JSONArray = JSONValue.fromRawValues(rawArray) {
            
            self = .Array(jsonArray)
            return
        }
        
        if let rawDictionary = rawValue as? [StringValue: Any] {
            
            var jsonObject = JSONObject(minimumCapacity: rawDictionary.count)
            
            for (key, rawValue) in rawDictionary {
                
                guard let jsonValue = JSONValue(rawValue: rawValue) else { return nil }
                
                jsonObject[key] = jsonValue
            }
            
            self = .Object(jsonObject)
            return
        }
        
        return nil
    }
}

public enum JSONNumber: RawRepresentable {
    
    case Boolean(Bool)
    
    case Integer(Int)
    
    case Float(FloatValue)
    
    case Double(DoubleValue)
    
    case Decimal(DecimalValue)
    
    // MARK: RawRepresentable
    
    public var rawValue: Any {
        
        switch self {
        case .Boolean(let value): return value
        case .Integer(let value): return value
        case .Float(let value):   return value
        case .Double(let value):  return value
        case .Decimal(let value): return value
        }
    }
    
    public init?(rawValue: Any) {
        
        if let value = rawValue as? Bool            { self = .Boolean(value) }
        if let value = rawValue as? Int             { self = .Integer(value) }
        if let value = rawValue as? FloatValue      { self = .Float(value)   }
        if let value = rawValue as? DoubleValue     { self = .Double(value)  }
        if let value = rawValue as? DecimalValue    { self = .Decimal(value) }
        
        return nil
    }
}

public protocol JSONEncodeable {
    
    /// Encodes the reciever into a JSON object.
    func toJSON() -> JSONObject
}

public protocol JSONDecodeable {
    
    /// Decodes the reciever from a JSON object.
    init?(JSONObject: JSONObject)
}

public protocol JSONValueConvertible {
    
    init?(JSONValue: JSONValue)
    
    func toJSON() -> JSONValue
}

// Typealiases due to compiler error

public typealias StringValue = String

public typealias FloatValue = Float

public typealias DoubleValue = Double

public typealias DecimalValue = Decimal

public typealias NullValue = Null



