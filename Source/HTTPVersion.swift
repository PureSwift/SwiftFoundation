//
//  HTTPVersion.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Defines the HTTP protocol version. Defualts to HTTP 1.1
public struct HTTPVersion {
    
    /** Major version number. */
    public var major: UInt8 = 1
    
    /** Minor version number. */
    public var minor: UInt8 = 1
}