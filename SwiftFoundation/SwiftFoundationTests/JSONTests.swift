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
                else { XCTFail("JSON parsing falied"); return }
            
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
    
    // MARK: - Performance Tests
    
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

}
