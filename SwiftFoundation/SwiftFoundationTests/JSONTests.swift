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
        
        writeJSON(JSON.Value.Object([
            "Key": JSON.Value.String("Value")
            ]))
        
        writeJSON(JSON.Value.Array([
            JSON.Value.String("value1"),
            JSON.Value.String("value2"),
            JSON.Value.Null,
            JSON.Value.Number(JSON.Number.Boolean(true)),
            JSON.Value.Number(JSON.Number.Integer(10)),
            JSON.Value.Number(JSON.Number.Double(10.10)),
            JSON.Value.Object(["Key": JSON.Value.String("Value")])
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
            
            let jsonObject = JSON.Value.Object(["date": JSON.Value.Number(JSON.Number.Boolean(true))])
            
            let rawValue = ["date": true]
            
            let jsonRawValue = (jsonObject.rawValue as! [String: Any]) as! [String: Bool]
            
            XCTAssert(jsonRawValue == rawValue)
        }
    }
    
    // MARK: - Performance Tests
    
    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

    func testFoundationPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    */

}
