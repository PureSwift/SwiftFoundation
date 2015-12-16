//
//  NSNull.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

extension SwiftFoundation.Null: FoundationConvertible {
    
    public init(foundation: NSNull) { self.init() }
    
    public func toFoundation() -> NSNull { return NSNull() }
}
