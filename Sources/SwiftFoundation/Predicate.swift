//
//  Predicate.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Defines logical conditions used to constrain a search either for a fetch or for in-memory filtering.
///
public protocol Predicate {
    
    /// Returns a Boolean value that indicates whether a given object matches the conditions specified by the predicate.
    ///
    func evaluate<T>(object: T) -> Bool
}

public extension Collection {
    
    func filter(predicate: Predicate) -> [Self.Iterator.Element] {
        
        return self.filter({ (element: Self.Iterator.Element) -> Bool in
            
            return predicate.evaluate(element)
        })
    }
}

/*
public extension Sequence {
    
    public func contains(predicate: Predicate -> Bool) -> Bool {
        
        return self.contains({ (element: Self.Iterator.Element) -> Bool in
            
            return predicate.evaluate(element)
        })
    }
}
*/