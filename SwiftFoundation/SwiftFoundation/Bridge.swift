//
//  Bridge.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Defines a type that can be created with the values of another type of same interface, but different implementation.
///
public protocol Bridgeable {
    
    /** The base interface for bridging. */
    typealias InterfaceType
    
    func bridge<T where T: Bridgeable, T.InterfaceType == Self.InterfaceType>() -> T
}