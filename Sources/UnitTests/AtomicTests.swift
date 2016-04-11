//
//  AtomicTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 4/11/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

final class AtomicTests: XCTestCase {
    
    static let allTests: [(String, AtomicTests -> () throws -> Void)] = [("testAtomic", testAtomic)]

    func testAtomic() {
        
        var atomic = Atomic(0)
        
        var thread2Finished = false
        
        var thread3Finished = false
        
        // thread 2
        let _ = try! Thread {
            
            for _ in 0 ..< 10 {
                
                atomic.value += 1
                
                print("\(atomic.value) (Thread 2)")
            }
            
            print("Finished thread 2")
            
            thread2Finished = true
        }
        
        // thread 3
        let _ = try! Thread {
            
            for _ in 0 ..< 10 {
                
                atomic.value += 1
                
                print("\(atomic.value) (Thread 3)")
            }
            
            print("Finished thread 3")
            
            thread3Finished = true
        }
        
        // main thread
        for _ in 0 ..< 10 {
            
            atomic.value += 1
            
            print("\(atomic.value) (Thread 1)")
        }
        
        let finalValue = 28
        
        print("Waiting for threads to finish")
        
        while thread2Finished == false || thread3Finished == false {
            
            sleep(1)
        }
        
        XCTAssert(atomic.value == finalValue, "Value is \(atomic.value), should be \(finalValue)")
        
        print("Final value \(atomic.value)")
    }
}
