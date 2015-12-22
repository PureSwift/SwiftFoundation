//
//  NSJSONSerialization.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import Foundation

public extension JSON.Value {
    
    /// Deserialize JSON from a string.
    public init?(string: Swift.String) {
        
        self.init(data: string.toUTF8Data().toFoundation())
    }
    
    /// Deserialize JSON from data.
    public init?(data: NSData) {
        
        guard let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()),
            let jsonValue = NSJSONSerialization.Value(rawValue: json)
            else { return nil }
        
        self.init(foundation: jsonValue)
    }
    
    /// Serializes the JSON into a string.
    public func toString(options: NSJSONWritingOptions = NSJSONWritingOptions.PrettyPrinted) -> Swift.String? {
        
        guard let data = self.toData(options)
            else { return nil }
        
        return Swift.String(UTF8Data: Data(foundation: data))!
    }
    
    /// Serializes the JSON into data.
    public func toData(options: NSJSONWritingOptions = NSJSONWritingOptions.PrettyPrinted) -> NSData? {
        
        switch self {
            
        case .Object(_), .Array(_): break
            
        default: return nil
        }
        
        return try! NSJSONSerialization.dataWithJSONObject(self.toFoundation().rawValue, options: options)
    }
}

public extension NSJSONSerialization {
    
    public enum Value: RawRepresentable {
        
        case Null
        
        case String(NSString)
        
        case Number(NSNumber)
        
        case Array([NSJSONSerialization.Value])
        
        case Dictionary([NSString: NSJSONSerialization.Value])
        
        public init?(rawValue: AnyObject) {
            
            guard (rawValue as? NSNull) == nil else {
                
                self = .Null
                return
            }
            
            if let string = rawValue as? NSString {
                
                self = .String(string)
                return
            }
            
            if let number = rawValue as? NSNumber {
                
                self = .Number(number)
                return
            }
            
            if let rawArray = rawValue as? [AnyObject], let jsonArray: [NSJSONSerialization.Value] = NSJSONSerialization.Value.fromRawValues(rawArray) {
                
                self = .Array(jsonArray)
                return
            }
            
            if let rawDictionary = rawValue as? [NSString: AnyObject] {
                
                typealias FoundationValue = NSJSONSerialization.Value
                
                var jsonObject = [NSString: FoundationValue](minimumCapacity: rawDictionary.count)
                
                for (key, rawValue) in rawDictionary {
                    
                    guard let jsonValue = NSJSONSerialization.Value(rawValue: rawValue) else { return nil }
                    
                    jsonObject[key] = jsonValue
                }
                
                self = .Dictionary(jsonObject)
                return
            }
            
            return nil
        }
        
        public var rawValue: AnyObject {
            
            switch self {
                
            case .Null: return NSNull()
                
            case .String(let string): return string
                
            case .Number(let number): return number
                
            case .Array(let array): return array.rawValues
                
            case .Dictionary(let dictionary):
                
                var dictionaryValue = [NSString: AnyObject](minimumCapacity: dictionary.count)
                
                for (key, value) in dictionary {
                    
                    dictionaryValue[key] = value.rawValue
                }
                
                return dictionaryValue
            }
            
        }
    }
}

extension JSON.Value: FoundationConvertible {
    
    public init(foundation: NSJSONSerialization.Value) {
        
        switch foundation {
            
        case .Null: self = .Null
            
        case .String(let value): self = JSON.Value.String(value as Swift.String)
            
        case .Number(let value):
            
            if value.isBool {
                
                self = JSON.Value.Number(JSON.Number.Boolean(value as Bool))
            }
                
            else if Swift.String.fromCString(value.objCType)! == intObjCType {
                
                self = JSON.Value.Number(.Integer(Int(value)))
            }
            else {
                
                self = JSON.Value.Number(.Double(Double(value)))
            }
            
        case .Array(let foundationArray):
            
            var jsonArray = JSONArray()
            
            for foundationValue in foundationArray {
                
                let jsonValue = JSON.Value(foundation: foundationValue)
                
                jsonArray.append(jsonValue)
            }
            
            self = .Array(jsonArray)
            
        case .Dictionary(let foundationDictionary):
            
            var jsonObject = JSONObject()
            
            for (key, foundationValue) in foundationDictionary {
                
                let jsonValue = JSON.Value(foundation: foundationValue)
                
                jsonObject[key as Swift.String] = jsonValue
            }
            
            self = .Object(jsonObject)
        }
    }
    
    public func toFoundation() -> NSJSONSerialization.Value {
        
        typealias FoundationValue = NSJSONSerialization.Value
        
        switch self {
            
        case .Null: return NSJSONSerialization.Value.Null
            
        case .String(let string): return NSJSONSerialization.Value.String(string as NSString)
            
        case .Number(let number):
            
            switch number {
                
                case let .Integer(value): return NSJSONSerialization.Value.Number(NSNumber(integer: value))
                
                case let .Double(value): return NSJSONSerialization.Value.Number(NSNumber(double: value))
                
                case let .Boolean(value): return NSJSONSerialization.Value.Number(NSNumber(bool: value))
            }
            
        case .Array(let array):
            
            var foundationArray = [FoundationValue]()
            
            for jsonValue in array {
                
                let foundationValue = jsonValue.toFoundation()
                
                foundationArray.append(foundationValue)
            }
            
            return .Array(foundationArray)
            
        case .Object(let dictionary):
            
            var foundationDictionary = [NSString: FoundationValue](minimumCapacity: dictionary.count)
            
            for (key, value) in dictionary {
                
                let foundationValue = value.toFoundation()
                
                foundationDictionary[key as NSString] = foundationValue
            }
            
            return .Dictionary(foundationDictionary)
        }
    }
}

private let trueNumber = NSNumber(bool: true)
private let falseNumber = NSNumber(bool: false)
private let trueObjCType = String.fromCString(trueNumber.objCType)
private let falseObjCType = String.fromCString(falseNumber.objCType)

private let intNumber = NSNumber(integer: 1)
private let intObjCType = String.fromCString(intNumber.objCType)!


extension NSNumber {
    var isBool:Bool {
        get {
            let objCType = String.fromCString(self.objCType)
            if (self.compare(trueNumber) == NSComparisonResult.OrderedSame && objCType == trueObjCType)
                || (self.compare(falseNumber) == NSComparisonResult.OrderedSame && objCType == falseObjCType){
                    return true
            } else {
                return false
            }
        }
    }
}

#endif



