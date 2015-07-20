//
//  URL.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Implementation

/// Type that represents a URL. URL will always be valid.
public struct URL: RawRepresentable {
    
    public let rawValue: String
    
    public let components: URLComponents
    
    public init?(rawValue: String) {
        
        guard let components = URLComponents(stringValue: rawValue) else { return nil }
        
        self.components = components
        
        self.rawValue = rawValue
    }
    
    /// Initializes the URL with the specified URL components. Returns ```nil``` if the components are invalid.
    public init?(components: URLComponents) {
        
        self.components = components
        
        guard let stringValue = components.URLString else { return nil }
        
        self.rawValue = stringValue
    }
}

/// Encapsulates the components of an URL.
public struct URLComponents {
    
    // MARK: - Properties
    
    public var scheme: String
    
    /// The host URL subcomponent
    public var host: String?
    
    public var port: UInt?
    
    public var path: String?
    
    public var authentication: (String, String)?
    
    /// The fragment URL component (the part after a # symbol)
    public var fragment: String?
    
    public var query: [String: String]?
    
    // MARK: - Initialization
    
    public init(scheme: String) {
        
        self.scheme = scheme
    }
    
    /// Creates an instance from the string. String must be a valid URL.
    public init?(stringValue: String) {
        
        // parse string
    }
    
    // MARK: - Generated Properties
    
    public var valid: Bool {
        
        guard !(host != nil && port == nil) else { return false }
        
        
        
        return true
    }
    
    public var URLString: String? {
        
        guard self.valid else { return nil }
        
        var stringValue = scheme + "://"
        
        
        
        return stringValue
    }
}

