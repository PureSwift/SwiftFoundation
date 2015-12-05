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
    
    // MARK: - Functional Tests

    func testEncode() {
        
        let string = "TestData 1234 $%^&* 😀"
        
        let inputData = string.toUTF8Data()
        
        let encodedData = Base64.encode(inputData)
        
        print("Base64 Encoded string: \(NSString(data: NSData(bytes: encodedData), encoding: NSUTF8StringEncoding))")
        
        let foundationEncodedData = NSData(bytes: inputData).base64EncodedDataWithOptions(NSDataBase64EncodingOptions())
        
        XCTAssert(encodedData == foundationEncodedData.arrayOfBytes())
    }
    
    /*
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
    */
    
    // MARK: - Performance Tests
    
    func generateEncodeData() -> Data {
        
        let pattern = "TestData 1234 $%^&* 😀"
        
        var string = pattern
        
        for _ in 0...100000 {
            
            string = string + pattern
        }
        
        let stringData = string.toUTF8Data()
        
        return stringData
    }
    
    func testEncodePerformance() {
        
        let data = generateEncodeData()
        
        measureBlock {
            
            let _ = Base64.encode(data)
        }
    }
    
    func testFoundationEncodePerformance() {
        
        let data = NSData(bytes: generateEncodeData())
        
        measureBlock {
            
            let _ = data.base64EncodedDataWithOptions(NSDataBase64EncodingOptions())
        }
    }
    
    func generateDecodeData() -> Data {
        
        let data = NSData(bytes: generateEncodeData())
        
        let encodedData = data.base64EncodedDataWithOptions(NSDataBase64EncodingOptions())
        
        return encodedData.arrayOfBytes()
    }
    
    func testDecodePerformance() {
        
        let data = generateDecodeData()
        
        measureBlock {
            
            let _ = Base64.decode(data)
        }
    }
    
    func testFoundationDecodePerformance() {
        
        let data = NSData(bytes: generateDecodeData())
        
        measureBlock {
            
            let _ = NSData(base64EncodedData: data, options: NSDataBase64DecodingOptions())
        }
    }
}


