//
//  cURLTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/2/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
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
        
        let url = "http://google.com"
        
        let port: UInt = 80
        
        try! curl.setOption(cURL.Option.URL(url))
        
        try! curl.setOption(cURL.Option.Port(port))
        
        var information: [cURL.Info]!
        
        do { information = try curl.info() }
        catch { XCTFail("Error: \(error)"); return }
        
        for info in information {
            
            switch info {
                
            case .EffectiveURL(let value): XCTAssert(value == url, value + " == " + url)
                
            default: continue
            }
        }
    }
    
    func testGetData() {
        
        let curl = cURL()
        
        try! curl.setOption(cURL.Option.URL("https://google.com"))
        
        try! curl.setOption(cURL.Option.Verbose(true))
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        var response: [cURL.Info]!
        do { response = try curl.info() }
        catch { XCTFail("Error getting cURL info: \(error)"); return }
        
        var responseCode: UInt!
        
        for info in response {
            
            switch info {
                
            case .ResponseCode(let code): responseCode = code
                
            default: continue
            }
        }
        
        XCTAssert(responseCode == 200, "Response code should be 200. (\(responseCode))")
    }

}
