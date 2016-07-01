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
        
        let data = testData.bytes.withUnsafeBufferPointer{ Data(bytes: $0.baseAddress!, count: testData.count) }
        
        XCTAssert(data == testData, "\(data) == \(testData)")
    }
}
