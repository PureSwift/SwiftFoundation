//
//  Null.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// An OOP placeholder for ```nil``` in collections. 
public struct Null: CustomStringConvertible, Equatable {
    
    public var description: String { return "Null" }
    
    public init() { }
}

// MARK: - Operator Overloading

public func == (lhs: Null, rhs: Null) -> Bool {
    
    return true
}
