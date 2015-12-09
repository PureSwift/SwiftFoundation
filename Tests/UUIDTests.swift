//
//  UUIDTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/2/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation
import SwiftFoundation

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
    
    func testStringPerformance() {
        
        let uuid = UUID()
        
        self.measureBlock { () -> Void in
            
            for _ in 0...10000 {
                
                _ = uuid.rawValue
            }
        }
    }
    
    func testFoundationStringPerformance() {
        
        let uuid = NSUUID()
        
        self.measureBlock { () -> Void in
            
            for _ in 0...10000 {
                
                _ = uuid.UUIDString
            }
        }
    }
}
