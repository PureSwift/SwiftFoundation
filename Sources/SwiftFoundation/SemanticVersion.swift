//
//  SemanticVersion.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

// MARK: - Implementation

public struct SemanticVersion: Equatable, RawRepresentable, CustomStringConvertible {
    
    // MARK: - Properties
    
    public var major: UInt
    
    public var minor: UInt
    
    public var patch: UInt
    
    // MARK: - Initialization
    
    public init(major: UInt, minor: UInt, patch: UInt) {
        
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public init?(rawValue: String) {
        
        // TODO: Implement RawRespresentable Initializer
        
        //let expression = "(\\d+).(\\d+).(\\d+)"
        
        return nil
    }
    
    // MARK: - Accessors
    
    public var rawValue: String {
        
        return "\(major).\(minor).\(patch)"
    }
    
    public var description: String {
        
        return rawValue
    }
}

// MARK: - Equatable

public func == (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
    
    return lhs.major == rhs.major
        && lhs.minor == rhs.minor
        && lhs.patch == rhs.patch
}
