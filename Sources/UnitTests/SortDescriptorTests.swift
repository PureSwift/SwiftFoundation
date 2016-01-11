//
//  SortDescriptorTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/3/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest
import SwiftFoundation

final class SortDescriptorTests: XCTestCase {
    
    lazy var allTests: [(String, () -> ())] =
        [("testComparableSorting", self.testComparableSorting),
        ("testComparatorSorting", self.testComparatorSorting)]
    
    // MARK: - Functional Tests

    func testComparableSorting() {
        
        let names = ["coleman", "Coleman", "alsey", "miller", "Z", "A"]
        
        do {
            
            let items = names
            
            let sortedItems = Sort(items, sortDescriptor: ComparableSortDescriptor(ascending: true))
            
            XCTAssert(["A", "Coleman", "Z", "alsey", "coleman", "miller"] == sortedItems)
        }
        
        do {
            
            let items = names
            
            let sortedItems = Sort(items, sortDescriptor: ComparableSortDescriptor(ascending: false))
            
            XCTAssert(["miller", "coleman", "alsey", "Z", "Coleman", "A"] == sortedItems)
        }
        
        let places = ["Lima, Peru", "Brazil", "Florida", "San Diego", "Hong Kong"]
        
        do {
            
            let items = places
            
            let sortedItems = Sort(items, sortDescriptor: ComparableSortDescriptor(ascending: true))
            
            XCTAssert(["Brazil", "Florida", "Hong Kong", "Lima, Peru", "San Diego"] == sortedItems)
        }
        
        do {
            
            let items = places
            
            let sortedItems = Sort(items, sortDescriptor: ComparableSortDescriptor(ascending: false))
            
            XCTAssert(["San Diego", "Lima, Peru", "Hong Kong", "Florida", "Brazil"] == sortedItems)
        }
    }
    
    func testComparatorSorting() {
        
        let names = ["coleman", "Coleman", "alsey", "miller", "Z", "A"]
        
        do {
            
            let items = names
            
            let sortedItems = Sort(items, sortDescriptor: ComparatorSortDescriptor(ascending: true, comparator: { (first: String, second: String) -> Order in
                
                return first.compare(second)
            }))
            
            XCTAssert(["A", "Coleman", "Z", "alsey", "coleman", "miller"] == sortedItems)
        }
        
        do {
            
            let items = names
            
            let sortedItems = Sort(items, sortDescriptor: ComparatorSortDescriptor(ascending: false, comparator: { (first: String, second: String) -> Order in
                
                return first.compare(second)
            }))
            
            XCTAssert(["miller", "coleman", "alsey", "Z", "Coleman", "A"] == sortedItems)
        }
        
        let places = ["Lima, Peru", "Brazil", "Florida", "San Diego", "Hong Kong"]
        
        do {
            
            let items = places
            
            let sortedItems = Sort(items, sortDescriptor: ComparatorSortDescriptor(ascending: true, comparator: { (first: String, second: String) -> Order in
                
                return first.compare(second)
            }))
            
            XCTAssert(["Brazil", "Florida", "Hong Kong", "Lima, Peru", "San Diego"] == sortedItems)
        }
        
        do {
            
            let items = places
            
            let sortedItems = Sort(items, sortDescriptor: ComparatorSortDescriptor(ascending: false, comparator: { (first: String, second: String) -> Order in
                
                return first.compare(second)
            }))
            
            XCTAssert(["San Diego", "Lima, Peru", "Hong Kong", "Florida", "Brazil"] == sortedItems)
        }
    }
}
