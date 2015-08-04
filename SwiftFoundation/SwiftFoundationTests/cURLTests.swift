//
//  cURLTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/2/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import cURL
@testable import SwiftFoundation

class cURLTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Live Tests
    
    func testGetStatusCode() {
        
        let curl = cURL()
        
        let testStatusCode = 200
        
        try! curl.setOption(CURLOPT_VERBOSE, true)
        
        try! curl.setOption(CURLOPT_URL, "http://httpbin.org/status/\(testStatusCode)")
        
        try! curl.setOption(CURLOPT_TIMEOUT, 10)
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        let responseCode: cURL.Long = try! curl.getInfo(CURLINFO_RESPONSE_CODE)
        
        XCTAssert(responseCode == testStatusCode, "\(responseCode) == \(testStatusCode)")
    }
    
    func testPostField() {
        
        let curl = cURL()
        
        try! curl.setOption(CURLOPT_VERBOSE, true)
        
        try! curl.setOption(CURLOPT_URL, "http://httpbin.org/post")
        
        try! curl.setOption(CURLOPT_TIMEOUT, 10)
        
        try! curl.setOption(CURLOPT_POST, true)
        
        let data: Data = [0x54, 0x65, 0x73, 0x74] // "Test"
        
        try! curl.setOption(CURLOPT_POSTFIELDS, data)
        
        try! curl.setOption(CURLOPT_POSTFIELDSIZE, data.count)
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        let responseCode: Int = try! curl.getInfo(CURLINFO_RESPONSE_CODE)
        
        XCTAssert(responseCode == 200, "\(responseCode) == 200")
    }

}
