//
//  NSURLSessionTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 10/2/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

class NSURLSessionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRequestConversion() {
        
        var headers = [String: String]()
        
        headers[RequestHeader.Date.rawValue] = "\(NSDate())"
        headers[RequestHeader.Authorization.rawValue] = "{username:QL5UUotH5+OjxoZWmB5i8NaZVCwyhY6580NpNJvBz56R4+sK6UqGG/7ok2sHvC8kRBQ8COvmDdOcAbkv4VzaM}"
        
        var request = HTTP.Request(URL: "http://localhost:8080")
        
        request.headers = headers
        
        let urlRequest = NSMutableURLRequest(request: request)!
        
        XCTAssert(request.headers == urlRequest.allHTTPHeaderFields!)
    }

}

public enum RequestHeader: String {
    
    case Date = "Date"
    case Authorization = "Authorization"
}