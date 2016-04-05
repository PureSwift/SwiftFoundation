//
//  JSONSerialization.swift
//  JSONC
//
//  Created by Alsey Coleman Miller on 8/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import JSON
#elseif os(Linux)
    import CJSONC
#endif

public extension JSON.Value {
    
    /// Serializes the JSON to a string.
    ///
    /// - Precondition: JSON value must be an array or object.
    ///
    /// - Note: Uses the [JSON-C](https://github.com/json-c/json-c) library.
    func toString(options: [JSON.WritingOption] = []) -> Swift.String? {
        
        switch self {
            
        case .Array(_), .Object(_): break
            
        default: return nil
        }
        
        let jsonObject = self.toJSONObject()
        
        defer { json_object_put(jsonObject) }
        
        let writingFlags = options.optionsBitmask()
        
        let stringPointer = json_object_to_json_string_ext(jsonObject, writingFlags)
        
        let string = Swift.String(validatingUTF8: stringPointer)!
        
        return string
    }
}

// MARK: - Private

private extension JSON.Value {
    
    func toJSONObject() -> OpaquePointer {
        
        switch self {
            
        case .Null: return nil
            
        case .String(let value): return json_object_new_string(value)
            
        case .Number(let number):
            
            switch number {
                
            case .Boolean(let value):
                
                let jsonBool: Int32 = { if value { return Int32(1) } else { return Int32(0) } }()
                
                return json_object_new_boolean(jsonBool)
                
            case .Integer(let value): return json_object_new_int64(Int64(value))
                
            case .Double(let value): return json_object_new_double(value)
            }
            
        case .Array(let arrayValue):
            
            let jsonArray = json_object_new_array()
            
            for (index, value) in arrayValue.enumerated() {
                
                let jsonValue = value.toJSONObject()
                
                json_object_array_put_idx(jsonArray, Int32(index), jsonValue)
            }
            
            return jsonArray
            
        case .Object(let dictionaryValue):
            
            let jsonObject = json_object_new_object()
            
            for (key, value) in dictionaryValue {
                
                let jsonValue = value.toJSONObject()
                
                json_object_object_add(jsonObject, key, jsonValue)
            }
            
            return jsonObject
        }
    }
}

