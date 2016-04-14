//
//  FileManagerTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/19/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import XCTest
import Foundation
import SwiftFoundation

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
        
        let fileName = "SwiftFoundationTestFileExists-\(UUID())"
        
        let path = NSTemporaryDirectory() + "/" + fileName
        
        XCTAssert(NSFileManager.defaultManager().createFile(atPath: path, contents: NSData(), attributes: nil))
        
        XCTAssert(FileManager.fileExists(at: path))
        
        XCTAssert(!FileManager.directoryExists(at: path))
    }
    
    func testDirectoryExists() {
        
        let path = try! NSFileManager.defaultManager().urlForDirectory( NSSearchPathDirectory.userDirectory, in: NSSearchPathDomainMask.allDomainsMask, appropriateFor: nil, create: false).path!
        
        assert(NSFileManager.defaultManager().fileExists(atPath: path, isDirectory: nil),
            "Setting non existent directory as test parameter")
        
        XCTAssert(FileManager.directoryExists(at: path))
        
        XCTAssert(!FileManager.fileExists(at: path))
    }
    
    func testReadFile() {
        
        // create file
        
        let bytes: [Byte] = "Test File: testReadFile 📱".utf8.map { (codeUnit) -> Byte in return codeUnit }
        
        let data = Data(byteValue: bytes)
        
        let fileName = "SwiftFoundationTestReadFile-\(UUID())"
        
        let path = NSTemporaryDirectory() + "/" + fileName + ".txt"
        
        XCTAssert(NSFileManager.defaultManager().createFile(atPath: path, contents: data.toFoundation(), attributes: nil))
        
        // read file
        
        var readData: Data
        
        do { readData = try FileManager.contents(at: path) }
        
        catch { XCTFail("\(error)"); return }
        
        XCTAssert(data == readData)
    }
    
    func testWriteFile() {
        
        // create file
        
        let bytes: [Byte] = "Test File: testWriteFile 📱".utf8.map { (codeUnit) -> Byte in return codeUnit }
        
        let data = Data(byteValue: bytes)
        
        let fileName = "SwiftFoundationTestWriteFile-\(UUID())"
        
        let path = NSTemporaryDirectory() + fileName + ".txt"
        
        // create empty file
        XCTAssert(NSFileManager.defaultManager().createFile(atPath: path, contents: NSData(), attributes: nil))
        
        // write file
        do { try FileManager.set(contents: data, at: path) }
        
        catch { XCTFail("\(error)"); return }
        
        // read file
        
        var readData: Data
        
        do { readData = try FileManager.contents(at: path) }
            
        catch { XCTFail("\(error)"); return }
        
        XCTAssert(data == readData)
    }
    
    func testCreateFile() {
        
        let data = "Test File: testCreateFile 📱".toUTF8Data()
        
        let fileName = "SwiftFoundationTestCreateFile-\(UUID())"
        
        let path = NSTemporaryDirectory() + fileName + ".txt"
        
        // create file 
        
        do { try FileManager.createFile(at: path, contents: data) }
        
        catch { XCTFail("\(error)"); return }
        
        // read data
        
        XCTAssert(NSFileManager.defaultManager().fileExists(atPath: path))
        
        NSFileManager.defaultManager()
        
        guard let readData = NSData(contentsOfFile: path)
            else { XCTFail("Could not read data"); return }
        
        XCTAssert(data == Data(foundation: readData))
    }
}
    
#endif

#if os(OSX) || os(iOS)
    public let TemporaryDirectory = NSTemporaryDirectory()
#elseif os(Linux)
    public let TemporaryDirectory = "/tmp/"
#endif

