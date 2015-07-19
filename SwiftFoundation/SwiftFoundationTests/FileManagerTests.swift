//
//  FileManagerTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/19/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import XCTest
@testable import SwiftFoundation

class FileManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetCurrentDirectory() {
        
        XCTAssert(FileManager.currentDirectory == NSFileManager.defaultManager().currentDirectoryPath)
    }
    
    func testFileExists() {
        
        let fileName = "SwiftFoundationTestFile\(NSDate())"
        
        let path = NSTemporaryDirectory() + "\\" + fileName
        
        XCTAssert(NSFileManager.defaultManager().createFileAtPath(path, contents: NSData(), attributes: nil))
        
        XCTAssert(FileManager.fileExists(atPath: path))
        
        XCTAssert(!FileManager.directoryExists(atPath: path))
    }
    
    func testDirectoryExists() {
        
        let path = try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.UserDirectory, inDomain: NSSearchPathDomainMask.AllDomainsMask, appropriateForURL: nil, create: false).path!
        
        assert(NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: nil),
            "Setting non existent directory as test parameter")
        
        XCTAssert(FileManager.directoryExists(atPath: path))
        
        XCTAssert(!FileManager.fileExists(atPath: path))
    }

}
