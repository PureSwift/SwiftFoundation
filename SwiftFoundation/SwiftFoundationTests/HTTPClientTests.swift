//
//  HTTPClientTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/9/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

class HTTPClientTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStatusCode() {
        
        let originalStatusCode = HTTP.StatusCode.OK
        
        var url = SwiftFoundation.URL(scheme: "http")
        
        url.host = "httpbin.org"
        
        url.path = "status/\(originalStatusCode.rawValue)"
        
        let request = HTTP.Request(URL: url)
        
        let client = HTTP.Client()
        
        var response: HTTP.Response!
        
        do { response = try client.sendRequest(request) }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.statusCode
        
        XCTAssert(UInt(statusCode) == originalStatusCode.rawValue, "\(UInt(statusCode)) == \(originalStatusCode.rawValue)")
    }

}
