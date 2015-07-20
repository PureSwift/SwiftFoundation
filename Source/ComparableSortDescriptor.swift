//
//  ComparableSortDescriptor.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/3/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Sorts ```Comparable``` types. */
public struct ComparableSortDescriptor<T: Comparable>: SortDescriptor {
        
    public let ascending: Bool
    
    public func sort(first: T, second: T) -> Order {
        
        return first.compare(second)
    }
    
    public init(ascending: Bool) {
        
        self.ascending = ascending
    }
}