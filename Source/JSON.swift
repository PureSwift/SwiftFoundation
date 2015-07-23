//
//  JSON.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public typealias JSONArray = [JSONValue]

public typealias JSONObject = [String: JSONValue]

// Typealiases only due to compiler error

public typealias JSONString = String

public typealias JSONInteger = Int

public enum JSONValue {
    
    case Null
    
    /// JSON value is a String Value
    case String(JSONString)
    
    /// JSON value is a Number Value (specific subtypes)
    case Number(JSONNumber)
    
    /// JSON value is an Array of other JSON values
    case Array(JSONArray)
    
    /// JSON value a JSON object
    case Object(JSONObject)
}

public enum JSONNumber {
    
    case Boolean(Bool)
    
    case Integer(Int)
    
    case Float(Float)
    
    case Double(Double)
    
    case Decimal(Decimal)
}