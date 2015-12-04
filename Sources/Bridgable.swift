//
//  Bridgable.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/20/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/** Used for bridging one type to another. */
public protocol Bridgeable {
    
    typealias BridgedType
    
    func bridge() -> BridgedType
}