//
//  JSONParse.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/10/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//
// Based on David Owens II's JSON parser in Swift
// https://github.com/owensd/json-swift
//

import JSON

public extension JSON.Value {
    
    /// creates JSON from string
    init?(string: Swift.String) {
        
        let tokenerError = UnsafeMutablePointer<json_tokener_error>.alloc(1)
        
        defer { tokenerError.dealloc(1) }
        
        let jsonObject = json_tokener_parse_verbose(string, tokenerError)
        
        // could not parse
        guard tokenerError != nil else { return nil }
        
        self.init(jsonObject: jsonObject)
    }
}

private extension JSON.Value {
    
    /// Create a JSON value from a ```json_object``` pointer created by the **json-c** library.
    init(jsonObject: COpaquePointer) {
        
        // defer { json_object_put(jsonObject) }
        
        let type = json_object_get_type(jsonObject)
        
        switch type {
            
        case json_type_null: self = .Null
            
        case json_type_string:
            
            let stringPointer = json_object_get_string(jsonObject)
            
            let string = Swift.String.fromCString(stringPointer)!
            
            self = JSON.Value.String(string)
            
        case json_type_boolean:
            
            let value = json_object_get_boolean(jsonObject)
            
            let boolean: Bool = {
                
                if value == 0 { return false }
                
                else { return true }
            }()
            
            self = .Number(.Boolean(boolean))
            
        case json_type_int:
            
            let value = json_object_get_int64(jsonObject)
            
            self = .Number(.Integer(Int(value)))
            
        case json_type_double:
            
            let value = json_object_get_double(jsonObject)
            
            self = .Number(.Double(value))
            
        case json_type_array:
            
            var array = [JSONValue]()
            
            let arrayLength = json_object_array_length(jsonObject)
            
            for (var i: Int32 = 0; i < arrayLength; i++) {
                
                let jsonValuePointer = json_object_array_get_idx(jsonObject, i)
                
                let jsonValue = JSON.Value(jsonObject: jsonValuePointer)
                
                array.append(jsonValue)
            }
            
            self = .Array(array)
            
        case json_type_object:
            
            let hashTable = json_object_get_object(jsonObject)
            
            var jsonDictionary = [StringValue: JSONValue]()
            
            var entry = hashTable.memory.head
            
            while entry != nil {
            
                let keyPointer = entry.memory.k
                
                let valuePointer = entry.memory.v
                
                let key = Swift.String.fromCString(unsafeBitCast(keyPointer, UnsafeMutablePointer<CChar>.self))!
                
                let value = json_object_get(unsafeBitCast(valuePointer, COpaquePointer.self))
                
                jsonDictionary[key] = JSON.Value(jsonObject: value)
                
                entry = entry.memory.next
            }
            
            self = .Object(jsonDictionary)
            
        default: fatalError("Unhandled case: \(type.rawValue)")
        }
    }
}


