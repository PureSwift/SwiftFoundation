//
//  URL.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Encapsulates the components of an URL.
public struct URL: CustomStringConvertible {
    
    // MARK: - Properties
    
    public var scheme: String
    
    public var user: String?
    
    public var password: String?
    
    /// The host URL subcomponent (e.g. domain name, IP address)
    public var host: String?
    
    public var port: UInt?
    
    public var path: String?
    
    public var query: [(String, String)]?
    
    /// The fragment URL component (the part after a # symbol)
    public var fragment: String?
    
    // MARK: - Initialization
    
    public init(scheme: String) {
        
        self.scheme = scheme
    }
    
    /// Creates an instance from the string. String must be a valid URL.
    public init?(stringValue: String) {
        
        // parse string
        
        debugPrint("URL parsing from string is not implemented yet!")
        
        return nil
    }
    
    // MARK: - Generated Properties
    
    /// Whether the URL components form a valid URL
    public var valid: Bool {
        
        // validate scheme
        
        // host must exist for port to be specified
        if port != nil { guard host != nil else { return false } }
        
        // user and password must both be nil or non-nil
        guard !((user != nil || password != nil) && (user == nil || password == nil)) else { return false }
        
        // query must have at least one item
        if query != nil { guard query!.count > 0 else { return false } }
        
        return true
    }
    
    /// Returns a valid URL string or ```nil```
    public var URLString: String? {
        
        guard self.valid else { return nil }
        
        var stringValue = scheme + "://"
        
        if let user = user { stringValue += user }
        
        if let password = password { stringValue += ":\(password)"}
        
        if user != nil { stringValue += "@" }
        
        if let host = host { stringValue += host }
        
        if let port = port { stringValue += ":\(port)" }
        
        if let path = path { stringValue += "/\(path)" }
        
        if let query = query {
            
            stringValue += "?"
            
            for (index, queryItem) in query.enumerate() {
                
                let (name, value) = queryItem
                
                stringValue += name + "=" + value
                
                if index != query.count - 1 {
                    
                    stringValue += "&"
                }
            }
        }
        
        if let fragment = fragment { stringValue += "#\(fragment)" }
        
        return stringValue
    }
    
    public var description: String {
        
        let separator = " "
        
        var description = ""
        
        if let URLString = URLString {
            
            description += "URL: " + URLString + separator
        }
            
        description += "Scheme: " + scheme
        
        if let user = user {
            
            description += separator + "User: " + user
        }
        
        if let password = password {
            
            description += separator + "Password: " + password
        }
        
        if let host = host {
            
            description += separator + "Host: " + host
        }
        
        if let port = port {
            
            description += separator + "Port: " + "\(port)"
        }
        
        if let path = path {
            
            description += separator + "Path: " + path
        }
        
        if let query = query {
            
            var stringValue = ""
            
            for (index, queryItem) in query.enumerate() {
                
                let (name, value) = queryItem
                
                stringValue += name + "=" + value
                
                if index != query.count - 1 {
                    
                    stringValue += "&"
                }
            }
            
            description += separator + "Query: " + stringValue
        }
        
        if let fragment = fragment {
            
            description += separator + "Fragment: " + fragment
        }
        
        return description
    }
}

