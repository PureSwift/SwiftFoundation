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
        
        try! curl.setOption(cURL.Option.URL("http://google.com"))
        
        try! curl.setOption(cURL.Option.Port(80))
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
        
        for info in response {
            
            switch info {
                
            case .ResponseCode(let code):
                XCTAssert(code == 200, "Response code should be 200. (\(code))")
                
            default: continue
            }
        }
    }

}
