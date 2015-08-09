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
        
        try! curl.setOption(CURLOPT_TIMEOUT, 5)
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        let responseCode: cURL.Long = try! curl.getInfo(CURLINFO_RESPONSE_CODE)
        
        XCTAssert(responseCode == testStatusCode, "\(responseCode) == \(testStatusCode)")
    }
    
    func testPostField() {
        
        let curl = cURL()
        
        let url = "http://httpbin.org/post"
        
        try! curl.setOption(CURLOPT_VERBOSE, true)
        
        try! curl.setOption(CURLOPT_URL, url)
        
        let effectiveURL = try! curl.getInfo(CURLINFO_EFFECTIVE_URL) as String
        
        XCTAssert(url == effectiveURL)
        
        try! curl.setOption(CURLOPT_TIMEOUT, 10)
        
        try! curl.setOption(CURLOPT_POST, true)
        
        let data: Data = [0x54, 0x65, 0x73, 0x74] // "Test"
        
        try! curl.setOption(CURLOPT_POSTFIELDS, data)
        
        try! curl.setOption(CURLOPT_POSTFIELDSIZE, data.count)
        
        do { try curl.perform() }
        catch { XCTFail("Error executing cURL request: \(error)"); return }
        
        let responseCode = try! curl.getInfo(CURLINFO_RESPONSE_CODE) as Int
        
        XCTAssert(responseCode == 200, "\(responseCode) == 200")
    }
    
    func testReadFunction() {
        
        let curl = cURL()
        
        try! curl.setOption(CURLOPT_VERBOSE, true)
        
        try! curl.setOption(CURLOPT_URL, "http://httpbin.org/post")
        
        try! curl.setOption(CURLOPT_TIMEOUT, 5)
        
        try! curl.setOption(CURLOPT_POST, true)
        
        let data: Data = [0x54, 0x65, 0x73, 0x74] // "Test"
        
        try! curl.setOption(CURLOPT_POSTFIELDSIZE, data.count)
        
        let dataStorage = cURL.ReadFunctionStorage(data: data)
        
        try! curl.setOption(CURLOPT_READDATA, unsafeBitCast(dataStorage, UnsafePointer<UInt8>.self))
        
        let pointer = unsafeBitCast(curlReadFunction as curl_read_callback, UnsafePointer<UInt8>.self)
        
        try! curl.setOption(CURLOPT_READFUNCTION, pointer)
        
        do { try curl.perform() }
        catch { print("Error executing cURL request: \(error)") }
        
        let responseCode = try! curl.getInfo(CURLINFO_RESPONSE_CODE) as Int
        
        XCTAssert(responseCode == 200, "\(responseCode) == 200")
    }
    
    func testWriteFunction() {
        
        let curl = cURL()
        
        try! curl.setOption(CURLOPT_VERBOSE, true)
        
        let url = "http://httpbin.org/image/jpeg"
        
        try! curl.setOption(CURLOPT_URL, url)
        
        try! curl.setOption(CURLOPT_TIMEOUT, 60)
        
        let storage = cURL.WriteFunctionStorage()
        
        try! curl.setOption(CURLOPT_WRITEDATA, unsafeBitCast(storage, UnsafeMutablePointer<UInt8>.self))
        
        try! curl.setOption(CURLOPT_WRITEFUNCTION, unsafeBitCast(cURL.WriteFunction, UnsafeMutablePointer<UInt8>.self))
        
        do { try curl.perform() }
        catch { print("Error executing cURL request: \(error)") }
        
        let responseCode = try! curl.getInfo(CURLINFO_RESPONSE_CODE) as Int
        
        XCTAssert(responseCode == 200, "\(responseCode) == 200")
        
        XCTAssert(NSData(bytes: unsafeBitCast(storage.data, Data.self)) == NSData(contentsOfURL: NSURL(string: url)!))

    }
    
    func testHeaderWriteFunction() {
        
        let curl = cURL()
        
        try! curl.setOption(CURLOPT_VERBOSE, true)
        
        let url = "http://httpbin.org"
        
        try! curl.setOption(CURLOPT_URL, url)
        
        try! curl.setOption(CURLOPT_TIMEOUT, 5)
        
        let storage = cURL.WriteFunctionStorage()
        
        try! curl.setOption(CURLOPT_HEADERDATA, unsafeBitCast(storage, UnsafeMutablePointer<UInt8>.self))
        
        try! curl.setOption(CURLOPT_HEADERFUNCTION, unsafeBitCast(cURL.WriteFunction, UnsafeMutablePointer<UInt8>.self))
        
        do { try curl.perform() }
        catch { print("Error executing cURL request: \(error)") }
        
        let responseCode = try! curl.getInfo(CURLINFO_RESPONSE_CODE) as Int
        
        XCTAssert(responseCode == 200, "\(responseCode) == 200")
        
        print("Header:\n\(String.fromCString(storage.data)!)")
    }
    
    func testSetHeaderOption() {
        
        var curl: cURL! = cURL()
        
        try! curl.setOption(CURLOPT_VERBOSE, true)
        
        let url = "http://httpbin.org/headers"
        
        try! curl.setOption(CURLOPT_URL, url)
        
        let header = "Header"
        
        let headerValue = "Value"
        
        try! curl.setOption(CURLOPT_HTTPHEADER, [header + ": " + headerValue])
        
        let storage = cURL.WriteFunctionStorage()
        
        try! curl.setOption(CURLOPT_WRITEDATA, unsafeBitCast(storage, UnsafeMutablePointer<UInt8>.self))
        
        try! curl.setOption(CURLOPT_WRITEFUNCTION, unsafeBitCast(curlWriteFunction as curl_write_callback, UnsafeMutablePointer<UInt8>.self))
        
        do { try curl.perform() }
        catch { print("Error executing cURL request: \(error)") }
        
        let responseCode = try! curl.getInfo(CURLINFO_RESPONSE_CODE) as Int
        
        XCTAssert(responseCode == 200, "\(responseCode) == 200")
        
        guard let json = try! NSJSONSerialization.JSONObjectWithData(NSData(bytes: unsafeBitCast(storage.data, Data.self)), options: NSJSONReadingOptions()) as? [String: [String: String]]
            else { XCTFail("Invalid JSON response"); return }
        
        guard let headersJSON = json["headers"]
            else { XCTFail("Invalid JSON response: \(json)"); return }
        
        XCTAssert(headersJSON[header] == headerValue)
        
        // invoke deinit
        curl = nil
    }
}
