//
//  FoundationConvertible.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

/// Type that can be converted to and from Apple's ***Foundation*** equivalent types.
public protocol FoundationConvertible {
    
    typealias FoundationType
    
    /// Initializes the type from Apple's **Foundation** equivalent type.
    init(foundation: FoundationType)
    
    /// Converts the type to an equivalent type for use with Apple's **Foundation**.
    func toFoundation() -> FoundationType
}