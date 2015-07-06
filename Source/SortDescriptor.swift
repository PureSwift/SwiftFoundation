//
//  SortDescriptor.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

/** Describes a basis for ordering types. */
public protocol SortDescriptor {
    
    typealias SortedType
    
    var ascending: Bool { get }
    
    /** Compares two types and gets their order. */
    func sort(SortedType, SortedType) -> Order
}

// MARK: - Functions

/** Returns a sorted array of the collection as specified by the sort descriptor. */
public func Sort<T: CollectionType, S: SortDescriptor where S.SortedType == T.Generator.Element>(collection: T, sortDescriptor: S) -> [T.Generator.Element] {
    
    return collection.sort { (first: T.Generator.Element, second: T.Generator.Element) -> Bool in
        
        let order = sortDescriptor.sort(first, second)
        
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
public func Sort<T: CollectionType, S: SortDescriptor where S.SortedType == T.Generator.Element>(collection: T, sortDescriptors: [S]) -> [T.Generator.Element] {
    
    var sortedArray = collection.map { (element: T.Generator.Element) -> T in }
    
    for sortDescriptor in sortDescriptors {
        
        sortedArray = Sort(sortDescriptor, collection: sortedArray)
    }
    
    return sortedArray
}
*/