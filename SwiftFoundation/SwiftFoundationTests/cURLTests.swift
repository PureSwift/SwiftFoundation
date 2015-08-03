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

    func testSetOption() {
        
        let curl = cURL()
        
        try! curl.setOption(cURL.Option.URL("https://google.com"))
        
        try! curl.setOption(cURL.Option.Port(80))
    }
    
    // MARK: - Live Tests
    
    func testGetStatusCode() {
        
        let curl = cURL()
        
        let testStatusCode = 200
        
        try! curl.setOption(cURL.Option.URL("http://httpbin.org/status/\(testStatusCode)"))
        
        try! curl.setOption(cURL.Option.Verbose(true))
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        let responseCode = try! curl.longForInfo(CURLINFO_RESPONSE_CODE)
        
        XCTAssert(responseCode == testStatusCode, "\(responseCode) == \(testStatusCode)")
    }

}
