//
//  Null.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** An OOP placeholder for ```nil```. */
public struct Null: CustomStringConvertible, Equatable {
    
    public var description: String { return "<null>" }
}

// MARK: - Operator Overloading

public func ==(lhs: Null, rhs: Null) -> Bool {
    
    return true
}