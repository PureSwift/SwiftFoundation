//
//  UUIDTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/2/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import XCTest
@testable import SwiftFoundation
import SwiftFoundationAppleBridge

class UUIDTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Functional Tests

    func testCreateRandomUUID() {
        
        // try to create without crashing
        
        do {
            
            _ = UUID()
        }
    }
    
    func testUUIDString() {
        
        let foundationUUID = NSUUID()
        
        let uuid = UUID(bytes: foundationUUID.byteValue)
        
        XCTAssert(foundationUUID.UUIDString == uuid.rawValue)
    }
    
    func testUUIDValidBytes() {
        
        let uuid = UUID()
        
        let foundationUUID = NSUUID(byteValue: uuid.byteValue)
        
        XCTAssert(uuid.rawValue == foundationUUID.UUIDString)
    }
    
    func testCreateFromString() {
        
        let stringValue = NSUUID().UUIDString
        
        XCTAssert((UUID(rawValue: stringValue) != nil), "Could not create UUID with string \"\(stringValue)\"")
        
        XCTAssert((UUID(rawValue: "BadInput") == nil), "UUID should not be created")
    }
    
    // MARK: - Performance Tests
    
    func testCreationPerformance() {
        
        self.measureBlock() {
            
            for _ in 0...1000000 {
                
                _ = UUID()
            }
        }
    }
    
    func testFoundationCreationPerformance() {
        
        self.measureBlock() {
            
            for _ in 0...1000000 {
                
                _ = NSUUID()
            }
        }
    }
}
