//
//  URLTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/20/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import XCTest
import SwiftFoundation

class URLTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /*
    func testBasicURLString() {
        
        let host = "google.com"
        
        let scheme = "http"
        
        var url = SwiftFoundation.URL(scheme: scheme)
        
        url.host = host
        
        let foundationURL = NSURLComponents()
        
        foundationURL.scheme = scheme
        
        foundationURL.host = host
        
        XCTAssert(foundationURL.URL != nil)
        
        XCTAssert(url.URLString != nil)
        
        //XCTAssert(url.URLString! == foundationURL.URL!.absoluteString)
    }
    */
}
