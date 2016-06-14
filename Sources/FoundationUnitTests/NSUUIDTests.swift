//
//  UUIDTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/2/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import XCTest
import Foundation
import SwiftFoundation

class NSUUIDTests: XCTestCase {

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
            
            let _ = SwiftFoundation.UUID()
        }
    }
    
    func testUUIDString() {
        
        let foundationUUID = NSUUID()
        
        let uuid = UUID(byteValue: foundationUUID.byteValue)
        
        XCTAssert(foundationUUID.uuidString == uuid.rawValue)
    }
    
    func testUUIDValidBytes() {
        
        let uuid = SwiftFoundation.UUID()
        
        let foundationUUID = NSUUID(byteValue: uuid.byteValue)
        
        XCTAssert(uuid.rawValue == foundationUUID.uuidString)
    }
    
    func testCreateFromString() {
        
        let stringValue = NSUUID().uuidString
        
        XCTAssert((UUID(rawValue: stringValue) != nil), "Could not create UUID with string \"\(stringValue)\"")
        
        XCTAssert((UUID(rawValue: "BadInput") == nil), "UUID should not be created")
    }
    
    // MARK: - Performance Tests
    
    func testCreationPerformance() {
        
        self.measure {
            
            for _ in 0...1000000 {
                
                _ = Foundation.UUID()
            }
        }
    }
    
    func testFoundationCreationPerformance() {
        
        self.measure {
            
            for _ in 0...1000000 {
                
                _ = NSUUID()
            }
        }
    }
    
    func testStringPerformance() {
        
        let uuid = SwiftFoundation.UUID()
        
        self.measure {
            
            for _ in 0...10000 {
                
                _ = uuid.rawValue
            }
        }
    }
    
    func testFoundationStringPerformance() {
        
        let uuid = NSUUID()
        
        self.measure {
            
            for _ in 0...10000 {
                
                _ = uuid.uuidString
            }
        }
    }
}

#endif

