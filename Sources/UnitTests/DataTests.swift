//
//  DataTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 1/10/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

final class DataTests: XCTestCase {
    
    lazy var allTests: [(String, () -> ())] =
    [("testFromBytePointer", self.testFromBytePointer)]

    func testFromBytePointer() {
        
        let string = "TestData"
        
        var testData = string.toUTF8Data()
        
        let dataLength = testData.byteValue.count
        
        let dataPointer = UnsafeMutablePointer<Byte>.alloc(dataLength)
        
        defer { dataPointer.dealloc(dataLength) }
        
        memset(&testData.byteValue, 0, dataLength)
        
        let data = Data.fromBytePointer(dataPointer, length: dataLength)
        
        XCTAssert(data == testData, "\(data) == \(testData)")
    }
}
