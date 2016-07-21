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
            
        case .array(_), .object(_): break
            
        default: return nil
        }
        
        let jsonObject = self.toJSONObject()
        
        defer { json_object_put(jsonObject) }
        
        let writingFlags = options.optionsBitmask()
        
        let stringPointer = json_object_to_json_string_ext(jsonObject, writingFlags)!
        
        let string = Swift.String(validatingUTF8: stringPointer)!
        
        return string
    }
}

// MARK: - Private

private extension JSON.Value {
    
    func toJSONObject() -> OpaquePointer? {
        
        switch self {
            
        case .null: return nil
            
        case .string(let value): return json_object_new_string(value)
            
        case .boolean(let value):
            
            let jsonBool: Int32 = { if value { return Int32(1) } else { return Int32(0) } }()
            
            return json_object_new_boolean(jsonBool)
            
        case .integer(let value): return json_object_new_int64(Int64(value))
            
        case .double(let value): return json_object_new_double(value)
            
        case .array(let arrayValue):
            
            let jsonArray = json_object_new_array()
            
            for (index, value) in arrayValue.enumerated() {
                
                let jsonValue = value.toJSONObject()
                
                json_object_array_put_idx(jsonArray, Int32(index), jsonValue)
            }
            
            return jsonArray
            
        case .object(let dictionaryValue):
            
            let jsonObject = json_object_new_object()
            
            for (key, value) in dictionaryValue {
                
                let jsonValue = value.toJSONObject()
                
                json_object_object_add(jsonObject, key, jsonValue)
            }
            
            return jsonObject
        }
    }
}

// MARK: - Supporting Types

public extension JSON {
    
    /// Options for serializing JSON.
    ///
    /// - Note: Uses the [JSON-C](https://github.com/json-c/json-c) library.
    public enum WritingOption: BitMaskOption {
        
        /// Causes the output to have minimal whitespace inserted to make things slightly more readable.
        case spaced
        
        /// Causes the output to be formatted. See the [Two Space Tab](http://jsonformatter.curiousconcept.com/) option
        /// for an example of the format.
        case pretty
        
        /// Drop trailing zero for float values
        case noZero
        
        public init?(rawValue: Int32) {
            
            switch rawValue {
                
            case JSON_C_TO_STRING_SPACED:       self = .spaced
            case JSON_C_TO_STRING_PRETTY:       self = .pretty
            case JSON_C_TO_STRING_NOZERO:       self = .noZero
                
            default: return nil
            }
        }
        
        public var rawValue: Int32 {
            
            switch self {
                
            case .spaced:        return JSON_C_TO_STRING_SPACED
            case .pretty:        return JSON_C_TO_STRING_PRETTY
            case .noZero:        return JSON_C_TO_STRING_NOZERO
            }
        }
    }
}

