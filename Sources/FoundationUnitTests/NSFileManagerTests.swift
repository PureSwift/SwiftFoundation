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
        
        XCTAssert(FileManager.currentDirectory == Foundation.FileManager.default().currentDirectoryPath)
    }
    
    func testFileExists() {
        
        let fileName = "SwiftFoundationTestFileExists-\(SwiftFoundation.UUID())"
        
        let path = NSTemporaryDirectory() + "/" + fileName
        
        XCTAssert(Foundation.FileManager.default().createFile(atPath: path, contents: Foundation.Data(), attributes: nil))
        
        XCTAssert(FileManager.fileExists(at: path))
        
        XCTAssert(!FileManager.directoryExists(at: path))
    }
    
    func testDirectoryExists() {
        
        let path = try! Foundation.FileManager.default().urlForDirectory(.userDirectory, in: .allDomainsMask, appropriateFor: nil, create: false).path!
        
        assert(Foundation.FileManager.default().fileExists(atPath: path, isDirectory: nil),
            "Setting non existent directory as test parameter")
        
        XCTAssert(FileManager.directoryExists(at: path))
        
        XCTAssert(!FileManager.fileExists(at: path))
    }
    
    func testReadFile() {
        
        // create file
        
        let bytes: [Byte] = "Test File: testReadFile 📱".utf8.map { (codeUnit) -> Byte in return codeUnit }
        
        let data = SwiftFoundation.Data(byteValue: bytes)
        
        let fileName = "SwiftFoundationTestReadFile-\(SwiftFoundation.UUID())"
        
        let path = NSTemporaryDirectory() + "/" + fileName + ".txt"
        
        XCTAssert(Foundation.FileManager.default().createFile(atPath: path, contents: data.toFoundation() as Foundation.Data, attributes: nil))
        
        // read file
        
        var readData: SwiftFoundation.Data
        
        do { readData = try SwiftFoundation.FileManager.contents(at: path) }
        
        catch { XCTFail("\(error)"); return }
        
        XCTAssert(data == readData)
    }
    
    func testWriteFile() {
        
        // create file
        
        let bytes: [Byte] = "Test File: testWriteFile 📱".utf8.map { (codeUnit) -> Byte in return codeUnit }
        
        let data = Data(byteValue: bytes)
        
        let fileName = "SwiftFoundationTestWriteFile-\(SwiftFoundation.UUID())"
        
        let path = NSTemporaryDirectory() + fileName + ".txt"
        
        // create empty file
        XCTAssert(Foundation.FileManager.default().createFile(atPath: path, contents: Foundation.Data(), attributes: nil))
        
        // write file
        do { try SwiftFoundation.FileManager.set(contents: data, at: path) }
        
        catch { XCTFail("\(error)"); return }
        
        // read file
        
        var readData: SwiftFoundation.Data
        
        do { readData = try FileManager.contents(at: path) }
            
        catch { XCTFail("\(error)"); return }
        
        XCTAssert(data == readData)
    }
    
    func testCreateFile() {
        
        let data = "Test File: testCreateFile 📱".toUTF8Data()
        
        let fileName = "SwiftFoundationTestCreateFile-\(SwiftFoundation.UUID())"
        
        let path = NSTemporaryDirectory() + fileName + ".txt"
        
        // create file 
        
        do { try FileManager.createFile(at: path, contents: data) }
        
        catch { XCTFail("\(error)"); return }
        
        // read data
        
        XCTAssert(Foundation.FileManager.default().fileExists(atPath: path))
        
        Foundation.FileManager.default()
        
        guard let readData = try? Foundation.Data(contentsOf: Foundation.URL(string: path)!)
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

