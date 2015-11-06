//
//  JSONExtensions.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 11/6/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

// MARK: - Primitive Types

// MARK: Encodable

extension String: JSONEncodable {
    
    public func toJSON() -> JSON.Value { return .String(self) }
}

extension String: JSONDecodable {
    
    public init?(JSONValue: JSON.Value) {
        
        guard let value = JSONValue.rawValue as? String else { return nil }
        
        self = value
    }
}

extension Int: JSONEncodable {
    
    public func toJSON() -> JSON.Value { return .Number(.Integer(self)) }
}

extension Int: JSONDecodable {
    
    public init?(JSONValue: JSON.Value) {
        
        guard let value = JSONValue.rawValue as? Int else { return nil }
        
        self = value
    }
}

extension Double: JSONEncodable {
    
    public func toJSON() -> JSON.Value { return .Number(.Double(self)) }
}

extension Double: JSONDecodable {
    
    public init?(JSONValue: JSON.Value) {
        
        guard let value = JSONValue.rawValue as? Double else { return nil }
        
        self = value
    }
}

extension Bool: JSONEncodable {
    
    public func toJSON() -> JSON.Value { return .Number(.Boolean(self)) }
}

extension Bool: JSONDecodable {
    
    public init?(JSONValue: JSON.Value) {
        
        guard let value = JSONValue.rawValue as? Bool else { return nil }
        
        self = value
    }
}

// MARK: - Collection Extensions

// MARK: Encodable

public extension CollectionType where Generator.Element: JSONEncodable {
    
    func toJSON() -> JSON.Value {
        
        var jsonArray = JSON.Array()
        
        for jsonEncodable in self {
            
            let jsonValue = jsonEncodable.toJSON()
            
            jsonArray.append(jsonValue)
        }
        
        return .Array(jsonArray)
    }
}

public extension Dictionary where Value: JSONEncodable, Key: StringLiteralConvertible {
    
    /// Encodes the reciever into JSON.
    func toJSON() -> JSON.Value {
        
        var jsonObject = JSON.Object()
        
        for (key, value) in self {
            
            let jsonValue = value.toJSON()
            
            let keyString = String(key)
            
            jsonObject[keyString] = jsonValue
        }
        
        return .Object(jsonObject)
    }
}

// MARK: Decodable

public extension JSONDecodable {
    
    /// Decodes from an array of JSON values.
    static func fromJSON(JSONArray: JSON.Array) -> [Self]? {
        
        var jsonDecodables = [Self]()
        
        for jsonValue in JSONArray {
            
            guard let jsonDecodable = self.init(JSONValue: jsonValue) else { return nil }
            
            jsonDecodables.append(jsonDecodable)
        }
        
        return jsonDecodables
    }
}

public extension JSONParametrizedDecodable {
    
    /// Decodes from an array of JSON values.
    static func fromJSON(JSONArray: JSON.Array, parameters: JSONDecodingParameters) -> [Self]? {
        
        var jsonDecodables = [Self]()
        
        for jsonValue in JSONArray {
            
            guard let jsonDecodable = self.init(JSONValue: jsonValue, parameters: parameters)
                else { return nil }
            
            jsonDecodables.append(jsonDecodable)
        }
        
        return jsonDecodables
    }
}
