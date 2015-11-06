//
//  JSONTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/12/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

class JSONTests: XCTestCase {
    
    // MARK: - Tests Setup

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Functional Tests
    
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
        
        func parseJSON(json: AnyObject) {
            
            let data = try! NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
            
            let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
            
            guard let jsonValue = JSON.Value(string: jsonString)
                else { XCTFail("JSON parsing failed"); return }
            
            print("Parsed JSON: \(jsonValue)\n")
        }
        
        parseJSON(["Key": NSNull()])
        
        parseJSON(["Key": "Value"])
        
        parseJSON(["Key": true])
        
        parseJSON(["Key": 10])
        
        parseJSON(["Key": 1.01])
        
        parseJSON(["Key": 10])
        
        parseJSON(["Key": ["Key2": "Value"]])
        
        parseJSON(["Key": ["Key2", "Value"]])
        
        parseJSON([true, false, 10, 10.10, "string", ["subarrayValue1", "subarrayValue2"], ["subobjectKey", "subobjectValue"]])
    }
    
    func testJSONWriting() {
        
        func writeJSON(json: JSON.Value) {
            
            guard let jsonString = json.toString()
                else { XCTFail("Could not serialize JSON"); return }
            
            let foundationJSONOutput = try! NSJSONSerialization.dataWithJSONObject(json.toFoundation().rawValue, options: NSJSONWritingOptions())
            
            let foundationJSONOutputString = NSString(data: foundationJSONOutput, encoding: NSUTF8StringEncoding)
            
            XCTAssert(jsonString == foundationJSONOutputString, "\(jsonString) == \(foundationJSONOutputString)")
            
            print("JSON Output: \(jsonString)")
        }
        
        writeJSON(.Object([
            "Key": .String("Value")
            ]))
        
        writeJSON(.Array([
            .String("value1"),
            .String("value2"),
            .Null,
            .Number(.Boolean(true)),
            .Number(.Integer(10)),
            .Number(.Double(10.10)),
            .Object(["Key": .String("Value")])
            ]))
    }
    
    func testRawValue() {
        
        /*
        do {
            
            let jsonArray = JSON.Value.Array([
                JSON.Value.String("value1"),
                JSON.Value.String("value2"),
                JSON.Value.Number(JSON.Number.Boolean(true)),
                JSON.Value.Number(JSON.Number.Integer(10)),
                JSON.Value.Number(JSON.Number.Double(10.10)),
                JSON.Value.Object(["Key": JSON.Value.String("Value")])
                ])
            
            let rawValue: [AnyObject] = ["value1", "value2", true, 10 as Int, 10.10 as Double, ["Key": "Value"]]
            
            let jsonRawValue = jsonArray.rawValue as? [AnyObject]
            
            XCTAssert(jsonRawValue! == rawValue)
        }
        */
        
        do {
            
            let jsonObject = JSON.Value.Object(["date": .Number(.Boolean(true))])
            
            let rawValue = ["date": true]
            
            let jsonRawValue = (jsonObject.rawValue as! [String: Any]) as! [String: Bool]
            
            XCTAssert(jsonRawValue == rawValue)
        }
    }
    
    // MARK: - Performance Tests
    
    let performanceJSON: JSON.Value = {
        
        var jsonArray = JSON.Array([
            .String("value1"),
            .String("value2"),
            .Null,
            .Number(.Boolean(true)),
            .Number(.Integer(10)),
            .Number(.Double(10.10)),
            .Object(["Key": .String("Value")])
            ])
        
        for _ in 0...10 {
            
            jsonArray += jsonArray
        }
        
        return JSON.Value.Array(jsonArray)
    }()
    
    func testWritingPerformance() {
        
        let jsonValue = performanceJSON
        
        measureBlock {
            
            let _ = jsonValue.toString()!
        }
    }
    
    func testFoundationWritingPerformance() {
        
        let jsonValue = performanceJSON
        
        let foundationJSON = jsonValue.toFoundation().rawValue as! NSArray
        
        measureBlock {
            
            let _ = try! NSJSONSerialization.dataWithJSONObject(foundationJSON, options: NSJSONWritingOptions())
        }
        
    }
    
    lazy var performanceJSONString: String = self.performanceJSON.toString()!
    
    func testParsePerformance() {
        
        let jsonString = performanceJSONString
        
        measureBlock {
            
            let _ = JSON.Value(string: jsonString)!
        }
    }
    
    func testFoundationParsePerformance() {
        
        let jsonString = performanceJSONString
        
        let jsonData = NSData(bytes: jsonString.toUTF8Data())
        
        measureBlock {
            
            let _ = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions())
        }
    }
}
