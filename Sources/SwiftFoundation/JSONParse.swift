//
//  JSONParse.swift
//  JSONC
//
//  Created by Alsey Coleman Miller on 8/10/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import JSON
#elseif os(Linux)
    import CJSONC
#endif

public extension JSON.Value {
    
    public init?(string: Swift.String) {
        
        let tokenerError: UnsafeMutablePointer<json_tokener_error>! = UnsafeMutablePointer<json_tokener_error>(allocatingCapacity: 1)
        
        defer { tokenerError.deallocateCapacity(1) }
        
        let jsonObject = json_tokener_parse_verbose(string, tokenerError)
        
        defer { json_object_put(jsonObject) }
        
        // could not parse
        guard tokenerError != nil else { return nil }
        
        self = self.dynamicType.init(jsonObject: jsonObject)
    }
}

private extension JSON.Value {
    
    /// Create a JSON value from a ```json_object``` pointer created by the **json-c** library.
    init(jsonObject: OpaquePointer?) {
        
        let type = json_object_get_type(jsonObject)
        
        switch type {
            
        case json_type_null: self = .Null
            
        case json_type_string:
            
            let stringPointer = json_object_get_string(jsonObject)!
            
            let string = Swift.String(validatingUTF8: stringPointer) ?? ""
            
            self = JSON.Value.String(string)
            
        case json_type_boolean:
            
            let value = json_object_get_boolean(jsonObject)
            
            let boolean: Bool = { if value == 0 { return false } else { return true } }()
            
            self = .Number(.Boolean(boolean))
            
        case json_type_int:
            
            let value = json_object_get_int64(jsonObject)
            
            // Handle integer overflow
            if value > Int64(Int.max) {
                
                self = .Number(.Integer(Int.max))
            }
            else {
                
                self = .Number(.Integer(Int(value)))
            }
            
        case json_type_double:
            
            let value = json_object_get_double(jsonObject)
            
            self = .Number(.Double(value))
            
        case json_type_array:
            
            var array = [JSONValue]()
            
            let arrayLength = json_object_array_length(jsonObject)
            
            for i in 0 ..< arrayLength {
                
                let jsonValuePointer = json_object_array_get_idx(jsonObject, i)
                
                let jsonValue = JSON.Value(jsonObject: jsonValuePointer)
                
                array.append(jsonValue)
            }
            
            self = .Array(array)
            
        case json_type_object:
            
            let hashTable = json_object_get_object(jsonObject)!
            
            var jsonDictionary = [StringValue: JSONValue]()
            
            var entry = hashTable.pointee.head
            
            while entry != nil {
            
                let keyPointer = entry!.pointee.k
                
                let valuePointer = entry!.pointee.v
                
                let key = Swift.String.init(validatingUTF8: unsafeBitCast(keyPointer, to: UnsafeMutablePointer<CChar>.self))!
                
                let value = json_object_get(unsafeBitCast(valuePointer, to: OpaquePointer.self))
                
                jsonDictionary[key] = JSON.Value(jsonObject: value)
                
                entry = entry!.pointee.next
            }
            
            self = .Object(jsonDictionary)
            
        default: fatalError("Unhandled case: \(type.rawValue)")
        }
    }
}


