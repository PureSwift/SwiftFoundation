//
//  JSONExtensions.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 11/6/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

// MARK: Protocol

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

// MARK: - Primitive Types

// MARK: Encodable

extension String: JSONEncodable {
    
    public func toJSON() -> JSON.Value { return .string(self) }
}

extension String: JSONDecodable {
    
    public init?(JSONValue: JSON.Value) {
        
        guard let value = JSONValue.rawValue as? String else { return nil }
        
        self = value
    }
}

extension Int: JSONEncodable {
    
    public func toJSON() -> JSON.Value { return .integer(self) }
}

extension Int: JSONDecodable {
    
    public init?(JSONValue: JSON.Value) {
        
        guard let value = JSONValue.rawValue as? Int else { return nil }
        
        self = value
    }
}

extension Double: JSONEncodable {
    
    public func toJSON() -> JSON.Value { return .double(self) }
}

extension Double: JSONDecodable {
    
    public init?(JSONValue: JSON.Value) {
        
        guard let value = JSONValue.rawValue as? Double else { return nil }
        
        self = value
    }
}

extension Bool: JSONEncodable {
    
    public func toJSON() -> JSON.Value { return .boolean(self) }
}

extension Bool: JSONDecodable {
    
    public init?(JSONValue: JSON.Value) {
        
        guard let value = JSONValue.rawValue as? Bool else { return nil }
        
        self = value
    }
}

// MARK: - Collection Extensions

// MARK: Encodable

public extension Collection where Iterator.Element: JSONEncodable {
    
    func toJSON() -> JSON.Value {
        
        let jsonArray = self.map { $0.toJSON() }
        
        return .array(jsonArray)
    }
}

public extension Dictionary where Value: JSONEncodable, Key: ExpressibleByStringLiteral {
    
    /// Encodes the reciever into JSON.
    func toJSON() -> JSON.Value {
        
        var jsonObject = JSON.Object(minimumCapacity: self.count)
        
        for (key, value) in self {
            
            let jsonValue = value.toJSON()
            
            let keyString = String(key)
            
            jsonObject[keyString] = jsonValue
        }
        
        return .object(jsonObject)
    }
}

// MARK: Decodable

public extension JSONDecodable {
    
    /// Decodes from an array of JSON values.
    static func from(JSON array: SwiftFoundation.JSON.Array) -> [Self]? {
        
        var jsonDecodables: ContiguousArray<Self> = ContiguousArray()
        
        jsonDecodables.reserveCapacity(array.count)
        
        for jsonValue in array {
            
            guard let jsonDecodable = self.init(JSONValue: jsonValue) else { return nil }
            
            jsonDecodables.append(jsonDecodable)
        }
        
        return Array(jsonDecodables)
    }
}

// MARK: - RawRepresentable Extensions

// MARK: Encode

public extension RawRepresentable where RawValue: JSONEncodable {
    
    /// Encodes the reciever into JSON.
    func toJSON() -> JSON.Value {
        
        return rawValue.toJSON()
    }
}

// MARK: Decode

public extension RawRepresentable where RawValue: JSONDecodable {
    
    /// Decodes the reciever from JSON.
    init?(JSONValue: JSON.Value) {
        
        guard let rawValue = RawValue(JSONValue: JSONValue) else { return nil }
        
        self.init(rawValue: rawValue)
    }
}
