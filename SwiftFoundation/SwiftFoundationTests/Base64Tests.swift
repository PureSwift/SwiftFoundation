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
        
        print("Base64 Encoded string: \(NSString(data: NSData(bytes: encodedData), encoding: NSUTF8StringEncoding))")
        
        let foundationEncodedData = inputData.base64EncodedDataWithOptions(NSDataBase64EncodingOptions())
        
        XCTAssert(encodedData == foundationEncodedData.arrayOfBytes())
    }
    
    func testDecode() {
        
        let string = "TestData 1234 😀"
        
        let inputData = string.dataUsingEncoding(NSUTF8StringEncoding)!.arrayOfBytes()
        
        let foundationEncodedData = NSData(bytes: inputData).base64EncodedDataWithOptions(NSDataBase64EncodingOptions()).arrayOfBytes()
        
        let decodedData = Base64.decode(foundationEncodedData)
        
        XCTAssert(decodedData != foundationEncodedData)
        
        XCTAssert(decodedData.count == inputData.count)
        
        XCTAssert(decodedData == inputData)
        
        let decodedString = NSString(data: NSData(bytes: decodedData), encoding: NSUTF8StringEncoding)!
        
        XCTAssert(decodedString == string)
        
        let foundationDecoded = NSData(base64EncodedData: NSData(bytes: foundationEncodedData), options: NSDataBase64DecodingOptions())!.arrayOfBytes()
        
        let foundationDecodedString = NSString(data: NSData(bytes: foundationDecoded), encoding: NSUTF8StringEncoding)!
        
        XCTAssert(foundationDecodedString == string)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
