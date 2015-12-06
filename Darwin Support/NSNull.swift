//
//  NSNull.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import Foundation

public extension SwiftFoundation.Null {
    
    init(foundation: NSNull) { self.init() }
    
    func toFoundation() -> NSNull { return NSNull() }
}

#endif
