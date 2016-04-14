//
//  SortDescriptor.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

// MARK: - Protocol

/// Describes a basis for ordering types.
public protocol SortDescriptor {
    
    associatedtype Sorted
    
    var ascending: Bool { get }
    
    /** Compares two types and gets their order. */
    func sort(first: Sorted, second: Sorted) -> Order
}

public extension Collection {
    
    /// Returns a sorted array of the collection as specified by the sort descriptor.
    func sorted<S: SortDescriptor where S.Sorted == Iterator.Element>(_ sortDescriptor: S) -> [Iterator.Element] {
        
        return self.sorted { (first: Iterator.Element, second: Iterator.Element) -> Bool in
            
            let order = sortDescriptor.sort(first: first, second: second)
            
            switch order {
                
            case .ascending: return sortDescriptor.ascending
                
            case .descending: return !sortDescriptor.ascending
                
            case .same: return true
                
            }
        }
    }
}
