//
//  DataTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 1/10/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

#if os(Linux)
    import Glibc
#endif

import XCTest
@testable import SwiftFoundation

final class DataTests: XCTestCase {
    
    static let allTests = [
        ("testFromBytePointer", testFromBytePointer)
    ]
    
    func testFromBytePointer() {
        /*
        let string = "TestData"
        
        let testData = Data(string.utf8)
        
        XCTAssert(testData.isEmpty == false, "Could not create test data")
        
        let dataPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: testData.count)
        
        defer { dataPointer.deallocate() }
        
        memcpy(dataPointer, testData.bytes, testData.count)
        
        let data = Data(bytes: dataPointer, count: testData.count)
        
        XCTAssert(data == testData, "\(data) == \(testData)")
    */
    }
}
