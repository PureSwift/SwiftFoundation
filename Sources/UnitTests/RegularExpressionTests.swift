//
//  RegularExpressionTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/11/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation
import Foundation

final class RegularExpressionTests: XCTestCase {
    
    static let allTests: [(String, (RegularExpressionTests) -> () throws -> Void)] =
        [("testSimpleRegex", testSimpleRegex),
        ("testExtendedRegex", testExtendedRegex),
        ("testMultipleSubexpressions", testMultipleSubexpressions),
        ("testEmoji", testEmoji)]

    func testSimpleRegex() {
        
        let regex = try! RegularExpression("Welcome")
        
        let string = "Welcome to RegExr v2.0 by gskinner.com!"
        
        guard let match = regex.match(string, options: [])
            else { XCTFail("Could not find match"); return }
        
        let stringRange = NSRange(match.range)
        
        let matchString = NSString(string: string).substring(with: stringRange)
        
        XCTAssert(matchString == "Welcome")
    }
    
    func testExtendedRegex() {
        
        do {
            
            let regex = try! RegularExpression("a{3}", options: [.ExtendedSyntax])
            
            let string = "lorem ipsum aaa"
            
            guard let match = regex.match(string, options: [])
                else { XCTFail("Could not find match"); return }
            
            let stringRange = NSRange(match.range)
            
            let matchString = NSString(string: string).substring(with: stringRange)
            
            XCTAssert(matchString == "aaa")
        }
        
        do {
            
            // match 5 letter word
            let regex = try! RegularExpression("[a-z, A-Z]{4}", options: [.ExtendedSyntax])
            
            let string = "Bird, Plane, Coleman"
            
            guard let match = regex.match(string, options: [])
                else { XCTFail("Could not find match"); return }
            
            let stringRange = NSRange(match.range)
            
            let matchString = NSString(string: string).substring(with: stringRange)
            
            XCTAssert(matchString == "Bird", matchString)
        }
    }
    
    func testMultipleSubexpressions() {
        
        let string = "/abc/xyz"
        
        let regex = try! RegularExpression("/([a-z]+)/([a-z]+)", options: [.ExtendedSyntax])
        
        guard let match = regex.match(string, options: [])
            else { XCTFail("Could not find match"); return }
        
        let stringRange = NSRange(match.range)
        
        let matchString = NSString(string: string).substring(with: stringRange)
        
        // matched whole string
        XCTAssert(matchString == string)
        
        // match subexpressions
        
        XCTAssert(match.subexpressionRanges.count == regex.subexpressionsCount, "Subexpressions should be \(regex.subexpressionsCount), is \(match.subexpressionRanges.count)")
    }
    
    func testEmoji() {
        
        let testString = "🙄😒🍺🦄"
        
        let beer = "🍺"
        
        let pattern = "\\(\(beer)\\)"
        
        do {
            let beerFinder = try RegularExpression(pattern)
            
            guard let match = beerFinder.match(testString) else {
                XCTFail("Could not find 🍺 in \(testString)")
                return
            }
            
            guard let beerRange = match.subexpressionRanges.first else {
                XCTFail("Could not find 🍺 capture group despite \(testString) match \(match)")
                return
            }
            
            guard let capturedString = testString.substring(range: beerRange) else {
                XCTFail("Failed to get a substring with range \(beerRange) in \(testString)")
                return
            }
            
            XCTAssertEqual(beer, capturedString, "Captured substring in \(beerRange) should match \(beer), but instead is \(capturedString)")
        } catch {
            
            XCTFail("Error thrown trying to create RegularExpression from \(pattern): \(error)")
        }
    }
}

#if os(Linux)

extension NSRange {
    
    init(_ range: Range<Int>) {
        
        self = NSRange(CountableRange(range))
    }
}

#endif
