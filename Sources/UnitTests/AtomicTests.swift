//
//  AtomicTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 4/11/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
#endif

import XCTest
import SwiftFoundation

final class AtomicTests: XCTestCase {
    
    static let allTests: [(String, (AtomicTests) -> () throws -> Void)] = [("testAtomic", testAtomic)]

    func testAtomic() {
        
        var atomic = Atomic(0)
                
        // main thread
        for i in 0 ..< 10 {
            
            let _ = try! Thread {
                
                let oldValue = atomic.value
                
                atomic.value += 1
                
                print("\(oldValue) -> \(atomic.value) (Thread \(i))")
            }
        }
        
        let finalValue = 10
        
        print("Waiting for threads to finish")
        
        while atomic.value != finalValue {
            
           sleep(1)
        }
        
        XCTAssert(atomic.value == finalValue, "Value is \(atomic.value), should be \(finalValue)")
        
        print("Final value \(atomic.value)")
    }
}
