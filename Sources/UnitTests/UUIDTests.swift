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
        let uuid = UUID()
        
        print(uuid)
    }
    
    func testUUIDString() {
        
        let stringValue = "5bfeb194-68c4-48e8-8f43-3c586364cb6f".uppercaseString
        
        guard let uuid = UUID(rawValue: stringValue)
            else { XCTFail("Could not create UUID from " + stringValue); return }
        
        XCTAssert(uuid.rawValue == stringValue, "UUID is \(uuid), should be \(stringValue)")
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
    
    func testStringPerformance() {
        
        let uuid = UUID()
        
        self.measureBlock { () -> Void in
            
            for _ in 0...10000 {
                
                _ = uuid.rawValue
            }
        }
    }
}
