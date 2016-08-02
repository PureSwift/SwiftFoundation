//
//  JSONTests.swift
//  JSONC
//
//  Created by Alsey Coleman Miller on 8/12/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

final class JSONTests: XCTestCase {
    
    static let allTests: [(String, (JSONTests) -> () throws -> Void)] = [
        
        ("testJSONEncodable", testJSONEncodable),
        ("testJSONParse", testJSONParse),
        ("testJSONWriting", testJSONWriting)
    ]
        
    func testJSONEncodable() {
        
        do {
            
            let string = "Hey"
            
            let json: JSON.Value = string.toJSON()
            
            guard let rawValue = json.rawValue as? String
                else { XCTFail("rawValue should be String"); return }
            
            XCTAssert(rawValue == string)
        }
    }

    func testJSONParse() {
        
        func parseJSON(_ jsonValue: JSON.Value, _ jsonString: String) {
            
            guard let parsedJSONValue = JSON.Value(string: jsonString)
                else { XCTFail("JSON parsing failed"); return }
            
            print("Parsed JSON: \(jsonValue)")
            
            XCTAssert(jsonValue == parsedJSONValue, "\(jsonValue) == \(parsedJSONValue)")
        }
        
        parseJSON(.object(["Key": .null]), "{ \"Key\" : null }")
        
        parseJSON(.object(["Key": .string("Value")]), "{ \"Key\" : \"Value\" }")
        
        parseJSON(.object(["Key": .boolean(true)]), "{ \"Key\" : true }")
        
        parseJSON(.object(["Key": .integer(10)]), "{ \"Key\" : 10 }")
        
        parseJSON(.object(["Key": .double(1.01)]), "{ \"Key\" : 1.01 }")
        
        parseJSON(.object(["Key": .object(["Key2": .string("Value")])]), "{ \"Key\" : { \"Key2\" : \"Value\" } }")
        
        parseJSON(.array([
            .boolean(true),
            .boolean(false),
            .integer(10),
            .double(10.1),
            .string("string"),
            .array([.string("subarrayValue1"), .string("subarrayValue2")]),
                .object(["subobjectKey": .string("subobjectValue")])
                ]), "[true, false, 10, 10.1, \"string\", [\"subarrayValue1\", \"subarrayValue2\"], {\"subobjectKey\" : \"subobjectValue\"} ]")
    }
    
    func testJSONWriting() {
        
        func writeJSON(_ json: JSON.Value, _ expectedJSONString: String) {
            
            guard let jsonString = json.toString()
                else { XCTFail("Could not serialize JSON"); return }
            
            XCTAssert(jsonString == expectedJSONString, "Does not match expected output. \(jsonString) == \(expectedJSONString)")
            
            print("JSON Output: \(jsonString)")
        }
        
        writeJSON(.object([
            "Key": .string("Value")
            ]), "{\"Key\":\"Value\"}")
                
        writeJSON(.array([
            .string("value1"),
            .string("value2"),
            .null,
            .boolean(true),
            .integer(10),
            .object(["Key": .string("Value")])
            ]), "[\"value1\",\"value2\",null,true,10,{\"Key\":\"Value\"}]")
    }
}
