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
import SwiftFoundation

final class DataTests: XCTestCase {
    
    static let allTests: [(String, (DataTests) -> () throws -> Void)] = [("testFromBytePointer", testFromBytePointer)]
    
    func testFromBytePointer() {
        
        let string = "TestData"
        
        let testData = string.toUTF8Data()
        
        XCTAssert(testData.isEmpty == false, "Could not create test data")
        
        let dataPointer = UnsafeMutablePointer<Byte>.allocate(capacity: testData.count)
        
        defer { dataPointer.deallocate(capacity: testData.count) }
        
        memcpy(dataPointer, testData.bytes, testData.count)
        
        let data = SwiftFoundation.Data(bytes: dataPointer, count: testData.count)
        
        XCTAssert(data == testData, "\(data) == \(testData)")
    }
}
