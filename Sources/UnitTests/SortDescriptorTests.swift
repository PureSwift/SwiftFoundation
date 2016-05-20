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
    
    static let allTests: [(String, (SortDescriptorTests) -> () throws -> Void)] =
        [("testComparableSorting", testComparableSorting),
        ("testComparatorSorting", testComparatorSorting)]
    
    // MARK: - Functional Tests

    func testComparableSorting() {
        
        let names = ["coleman", "Coleman", "alsey", "miller", "Z", "A"]
        
        do {
            
            let items = names
            
            let sortedItems = items.sorted(ComparableSortDescriptor(ascending: true))
            
            let expected = items.sorted()
            
            XCTAssert(expected == sortedItems, "Ascending: \(expected) == \(sortedItems)")
        }
        
        do {
            
            let items = names
            
            let sortedItems = items.sorted(ComparableSortDescriptor(ascending: false))
            
            let expected = Array(items.sorted().reversed())
            
            XCTAssert(expected == sortedItems, "Descending: \(expected) == \(sortedItems)")
        }
        
        let places = ["Lima, Peru", "Brazil", "Florida", "San Diego", "Hong Kong"]
        
        do {
            
            let items = places
            
            let sortedItems = items.sorted(ComparableSortDescriptor(ascending: true))
            
            let expected = items.sorted()
            
            XCTAssert(expected == sortedItems, "\(expected) == \(sortedItems)")
        }
        
        do {
            
            let items = places
            
            let sortedItems = items.sorted(ComparableSortDescriptor(ascending: false))
            
            let expected = Array(items.sorted().reversed())
            
            XCTAssert(expected == sortedItems, "\(expected) == \(sortedItems)")
        }
    }
    
    func testComparatorSorting() {
        
        let names = ["coleman", "Coleman", "alsey", "miller", "Z", "A"]
        
        do {
            
            let items = names
            
            let sortedItems = items.sorted(ComparatorSortDescriptor(ascending: true, comparator: { (first: String, second: String) -> Order in
                
                return first.compare(second)
            }))
            
            let expected = items.sorted()
            
            XCTAssert(expected == sortedItems, "\(expected) == \(sortedItems)")
        }
        
        do {
            
            let items = names
            
            let sortedItems = items.sorted(ComparatorSortDescriptor(ascending: false, comparator: { (first: String, second: String) -> Order in
                
                return first.compare(second)
            }))
            
            let expected = Array(items.sorted().reversed())
            
            XCTAssert(expected == sortedItems, "\(expected) == \(sortedItems)")
        }
        
        let places = ["Lima, Peru", "Brazil", "Florida", "San Diego", "Hong Kong"]
        
        do {
            
            let items = places
            
            let sortedItems = items.sorted(ComparatorSortDescriptor(ascending: true, comparator: { (first: String, second: String) -> Order in
                
                return first.compare(second)
            }))
            
            XCTAssert(["Brazil", "Florida", "Hong Kong", "Lima, Peru", "San Diego"] == sortedItems)
        }
        
        do {
            
            let items = places
            
            let sortedItems = items.sorted(ComparatorSortDescriptor(ascending: false, comparator: { (first: String, second: String) -> Order in
                
                return first.compare(second)
            }))
            
            XCTAssert(["San Diego", "Lima, Peru", "Hong Kong", "Florida", "Brazil"] == sortedItems)
        }
    }
}
