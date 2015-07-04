//
//  URL.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

public protocol URLType: RawRepresentable, CustomStringConvertible, Equatable {
    
    var host: String { get }
    
    var rawValue: String { get }
    
    init?(rawValue: String)
}

// MARK: - Protocol Extension

public extension URLType {
    
    var host: String {
        
        // TODO: Implement 'host' extraction
        
        return ""
    }
}

// MARK: - Implementation

public struct URL: URLType {
    
    public let rawValue: String
    
    public init?(rawValue: String) {
        
        guard rawValue.characters.count > 1 else {
            
            return nil
        }
        
        self.rawValue = rawValue
    }
}