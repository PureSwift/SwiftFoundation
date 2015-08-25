//
//  Base64Tests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/23/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

class Base64Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEncode() {
        
        let string = "TestData 1234 $%^&* 😀"
        
        let inputData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let encodedData = Base64.encode(inputData.arrayOfBytes())
        
        let foundationEncodedData = inputData.base64EncodedDataWithOptions(NSDataBase64EncodingOptions())
        
        XCTAssert(encodedData == foundationEncodedData.arrayOfBytes())
    }
    
    func testDecode() {
        
        let inputData = NSData(contentsOfURL: NSURL(string: "http://google.com")!)!
        
        let encodedData = Base64.encode(inputData.arrayOfBytes())
        
        let foundationEncodedData = inputData.base64EncodedDataWithOptions(NSDataBase64EncodingOptions())
        
        XCTAssert(encodedData == foundationEncodedData.arrayOfBytes())
        
        let decodedData = Base64.decode(encodedData)
        
        print("Swift Decoded: \(NSString(data: NSData(bytes: encodedData), encoding: NSASCIIStringEncoding)!)")
        
        let foundationDecoded = NSData(base64EncodedData: NSData(bytes: encodedData), options: NSDataBase64DecodingOptions())!
        
        print("NSData Decoded: \(NSString(data: foundationDecoded, encoding: NSASCIIStringEncoding)!)")
        
        XCTAssert(decodedData == foundationDecoded.arrayOfBytes())
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
