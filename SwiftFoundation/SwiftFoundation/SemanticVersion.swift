//
//  SemanticVersion.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

public protocol SemanticVersionType: RawRepresentable, CustomStringConvertible {
    
    var mayor: UInt { get }
    
    var minor: UInt { get }
    
    var patch: UInt { get }
}

// MARK: - Protocol Implementation

public extension SemanticVersionType {
    
    var rawValue: String {
        
        return "\(mayor).\(minor).\(patch)"
    }
    
    var description: String {
        
        return rawValue
    }
    
    init?(rawValue: String) {
        
        // TODO: Implement RawRespresentable Initializer
        
        return nil
    }
}

// MARK: - Implementation

public struct SemanticVersion: SemanticVersionType {
    
    // MARK: - Properties
    
    public let mayor: UInt
    
    public let minor: UInt
    
    public let patch: UInt
    
    public init(mayor: UInt, minor: UInt, patch: UInt) {
        
        self.mayor = mayor
        self.minor = minor
        self.patch = patch
    }
}