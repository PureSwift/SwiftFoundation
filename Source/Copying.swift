//
//  Copying.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/17/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Protocol for classes that can create equivalent duplicates of themselves.
/// *Use case:* Classes that incapsuate information that need to be passed by referenced (can't be structs). but need copying for thread safety, immutablility etc.
public protocol Copying: class {
    
    /// Makes a copy of the reciever.
    /// Duplicate is implied to be of the same mutablility as the reciever.
    var copy: Self { get }
}

/// Protocol for classes that have mutable and immutable types.
public protocol MutableCopying: Copying {
    
    /// Makes a mutable copy of the reciever.
    var mutableCopy: Self { get }
}