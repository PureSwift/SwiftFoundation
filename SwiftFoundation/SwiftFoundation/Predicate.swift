//
//  Predicate.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Defines logical conditions used to constrain a search either for a fetch or for in-memory filtering.
///
public protocol Predicate {
    
    /// Returns a Boolean value that indicates whether a given object matches the conditions specified by the predicate.
    ///
    func evaluate<T>(object: T) -> Bool
}

public extension Array {
    
    func filteredArrayUsingPredicate(predicate: Predicate) -> Array {
        
        return self.filter({ (element: Array.Generator.Element) -> Bool in
            
            return predicate.evaluate(element)
        })
    }
}

/*
public extension CollectionType {
    
    func filteredUsingPredicate(predicate: Predicate) -> Self {
        
        var copy = self
        
        for i in startIndex..<endIndex {
            
            copy[i] = nil
        }
        
        
    }
}

public extension MutableCollectionType {
    
    /// Evaluate each object in the set using the specified predicate and remove each objects which evaluates to NO.
    ///
    mutating func filterUsingPredicate(predicate: Predicate) {
        
        for index in startIndex..<endIndex {
            
            let element = self[index]
            
            if predicate.evaluate(element) == false {
                
                self[index] = nil
            }
        }
    }
}
*/
