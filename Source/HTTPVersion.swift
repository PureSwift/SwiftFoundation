//
//  HTTPVersion.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** defines the HTTP protocol version. */
public struct HTTPVersion {
    
    /** Major version number. */
    public let major: UInt8
    
    /** Minor version number. */
    public let minor: UInt8
    
    /** Defaults to ```1.1``` */
    public init(major: UInt8 = 1, minor: UInt8 = 1) {
        
        self.major = major
        self.minor = minor
    }
}