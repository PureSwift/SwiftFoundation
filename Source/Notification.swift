//
//  Notification.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/** The name of the notification. */
public struct Notification<Sender: AnyObject>: CustomStringConvertible {
    
    /// The name of the notification.
    public var name: String
    
    /// The notification's domain.
    public var domain: String
    
    /// The object that sent the notification.
    public var sender: Sender?
    
    /// Accompanying payload for the notification.
    public var userInfo: [String: Any]?
    
    public init(name: String, domain: String, userInfo: [String: Any]? = nil, sender: Sender? = nil) {
        
        self.name = name
        self.domain = domain
        self.userInfo = userInfo
        self.sender = sender
    }
    
    public var description: String {
        
        var description = "Name: \(name), Domain: \(domain)"
        
        if userInfo != nil {
            
            description += " UserInfo: \(userInfo!)"
        }
        
        return description
    }
}