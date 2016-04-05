//
//  SortDescriptor.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

// MARK: - Protocol

/** Describes a basis for ordering types. */
public protocol SortDescriptorType {
    
    associatedtype SortedType
    
    var ascending: Bool { get }
    
    /** Compares two types and gets their order. */
    func sort(first: SortedType, second: SortedType) -> Order
}

// MARK: - Functions

/** Returns a sorted array of the collection as specified by the sort descriptor. */
public func Sort<T: Collection, S: SortDescriptorType where S.SortedType == T.Iterator.Element>(collection: T, sortDescriptor: S) -> [T.Iterator.Element] {
    
    return collection.sorted { (first: T.Iterator.Element, second: T.Iterator.Element) -> Bool in
        
        let order = sortDescriptor.sort(first, second: second)
        
        let first: Bool = {
            
            switch order {
                
            case .Ascending: return sortDescriptor.ascending
                
            case .Descending: return !sortDescriptor.ascending
                
            case .Same: return true
                
            }
        }()
        
        return first
    }
}

/*
/** Returns a sorted array if the collection sorted as specified by a given array of sort descriptors. */
public func Sort<T: CollectionType, S: SortDescriptor where S.SortedType == T.Iterator.Element>(collection: T, sortDescriptors: [S]) -> [T.Iterator.Element] {
    
    var sortedArray = collection.map { (element: T.Iterator.Element) -> T in }
    
    for sortDescriptor in sortDescriptors {
        
        sortedArray = Sort(sortDescriptor, collection: sortedArray)
    }
    
    return sortedArray
}
*/