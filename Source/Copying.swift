//
//  Copying.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/17/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Protocol for classes that can create equivalent duplicates of themselves.
///
/// Duplicate is implied to be of the same mutablility as the reciever.
/// The copy returned is immutable if the consideration “immutable vs. mutable” applies to the receiving object; otherwise the exact nature of the copy is determined by the class.
///
/// **Use Case:** Classes that incapsuate information that need to be passed by reference (can't be structs), but need copying for thread safety, immutablility etc.
public protocol Copying: class {
    
    /// Creates a copy of the reciever.
    var copy: Self { get }
}

/// Protocol for classes that have mutable and immutable types.
///
/// Only classes that define an “immutable vs. mutable” distinction should adopt this protocol. Classes that don’t define such a distinction should adopt ```Copying``` instead.
public protocol MutableCopying: class, Copying {
    
    typealias MutableType
    
    /// Creates a mutable copy of the reciever.
    var mutableCopy: MutableType { get }
}