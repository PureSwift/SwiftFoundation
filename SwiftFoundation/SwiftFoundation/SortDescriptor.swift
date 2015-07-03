//
//  SortDescriptor.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Describes a basis for ordering types. */
public protocol SortDescriptor {
    
    typealias SortedType
    
    var ascending: Bool { get }
    
    /** Compares two types and gets their order. */
    func sort(SortedType, SortedType) -> Order
}

public extension CollectionType where SortDescriptor.SortedType: AnyObject {
    
    func sort(sortDescriptors: [SortDescriptor]) -> [Self.Generator.Element] {
        
        self.sort { (first: Self.Generator.Element, second: Self.Generator.Element) -> Bool in
            
            
        }
    }
}

public func Sort<T: CollectionType, S: SortDescriptor>(sortDescriptors: [S], collection: T) -> [T.Generator.Element] {
    
    collection.sort { (first: T.Generator.Element, second: T.Generator.Element) -> Bool in
        
        
    }
}