//
//  UUIDTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/2/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif
import XCTest
@testable import SwiftFoundation

final class UUIDTests: XCTestCase {
    
    static let allTests = [
        ("testEquality", testEquality),
        ("testInvalid", testInvalid),
        ("testString", testString),
        ("testDescription", testDescription),
        ("testHashable", testHashable),
        ("testCodable", testCodable),
        ("testCreateRandomUUID", testCreateRandomUUID),
        ("testUUIDString", testUUIDString),
        ("testCreateFromString", testCreateFromString),
        ("testBytes", testBytes)
    ]
    
    typealias UUID = SwiftFoundation.UUID
    
    func testEquality() {
        let uuidA = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        let uuidB = UUID(uuidString: "e621e1f8-c36c-495a-93fc-0c247a3e6e5f")
        let uuidC = UUID(uuid: (0xe6,0x21,0xe1,0xf8,0xc3,0x6c,0x49,0x5a,0x93,0xfc,0x0c,0x24,0x7a,0x3e,0x6e,0x5f))
        let uuidD = UUID()
        
        XCTAssertEqual(uuidA, uuidB, "String case must not matter.")
        XCTAssertEqual(uuidA, uuidC, "A UUID initialized with a string must be equal to the same UUID initialized with its UnsafePointer<UInt8> equivalent representation.")
        XCTAssertNotEqual(uuidC, uuidD, "Two different UUIDs must not be equal.")
    }
    
    func testInvalid() {
        let uuid = UUID(uuidString: "Invalid UUID")
        XCTAssertNil(uuid, "The convenience initializer `init?(uuidString string:)` must return nil for an invalid UUID string.")
    }
    
    func testString() {
        let uuid = UUID(uuid: (0xe6,0x21,0xe1,0xf8,0xc3,0x6c,0x49,0x5a,0x93,0xfc,0x0c,0x24,0x7a,0x3e,0x6e,0x5f))
        XCTAssertEqual(uuid.uuidString, "E621E1F8-C36C-495A-93FC-0C247A3E6E5F", "The uuidString representation must be uppercase.")
    }
    
    func testDescription() {
        let uuid = UUID()
        XCTAssertEqual(uuid.description, uuid.uuidString, "The description must be the same as the uuidString.")
    }
    
    func testHashable() {
        let uuid = UUID()
        XCTAssertEqual(uuid.hashValue, uuid.hashValue)
        XCTAssertNotEqual(uuid.hashValue, 0)
        XCTAssertNotEqual(uuid.hashValue, UUID().hashValue)
    }
    
    #if canImport(Foundation)
    
    /// Needs JSONEncoder / JSONDecoder
    func testCodable() {
        
        let uuid = UUID(uuidString: "5BFEB194-68C4-48E8-8F43-3C586364CB6F")!
        let value = ["uuid": uuid]
        let data = Foundation.Data(#"{"uuid":"5BFEB194-68C4-48E8-8F43-3C586364CB6F"}"#.utf8)
        let encoder = JSONEncoder()
        XCTAssertEqual(try encoder.encode(value), data)
        let decoder = JSONDecoder()
        XCTAssertEqual(try decoder.decode(type(of: value), from: data), value)
    }
    
    #endif
    
    func testCreateRandomUUID() {
        
        // try to create without crashing
        let uuid = UUID()
        print(uuid)
    }
    
    func testUUIDString() {
        
        let stringValue = "5BFEB194-68C4-48E8-8F43-3C586364CB6F"
        
        guard let uuid = UUID(uuidString: stringValue)
            else { XCTFail("Could not create UUID from " + stringValue); return }
        
        XCTAssert(uuid.uuidString == stringValue, "UUID is \(uuid), should be \(stringValue)")
    }
    
    func testCreateFromString() {
        
        let stringValue = "5BFEB194-68C4-48E8-8F43-3C586364CB6F"
        XCTAssert((UUID(uuidString: stringValue) != nil), "Could not create UUID with string \"\(stringValue)\"")
        XCTAssert((UUID(uuidString: "BadInput") == nil), "UUID should not be created")
    }
    
    func testBytes() {
                
        let bytes: uuid_t = (91, 254, 177, 148, 104, 196, 72, 232, 143, 67, 60, 88, 99, 100, 203, 111)
        
        let stringValue = "5BFEB194-68C4-48E8-8F43-3C586364CB6F"
        
        XCTAssertEqual(UUID(uuidString: stringValue), UUID(uuid: bytes), "Unexpected UUID data")
    }
}
