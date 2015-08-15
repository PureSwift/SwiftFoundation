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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSimpleJSONParse() {
        
        //let rawJSON = "{   \"Key\" : [true, null, false, 12345, 1234.666, {\"Key2\": \"value\"}, \"string\"] }"
        
        let jsonObject = ["Key": "Value"]
        
        let data = try! NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.PrettyPrinted).arrayOfBytes()
        
        guard let jsonValue = JSON.Value(UTF8Data: data)
            else { XCTFail("JSON parsing falied"); return }
        
        print(jsonValue)
    }
    
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
