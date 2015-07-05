//
//  Notification.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

/** Notification type. */
public protocol NotificationType: CustomStringConvertible {
    
    typealias Sender: AnyObject
    
    /** The name of the notification. */
    var name: String { get }
    
    /** The notification's domain. */
    var domain: String { get }
    
    /** The object that sent the notification. */
    var sender: Sender? { get }
    
    /** Accompanying payload for the notification. */
    var userInfo: [String: Any]? { get }
    
    /** Default initializer. */
    init(name: String, domain: String, userInfo: [String: Any]?, sender: Sender?)
}

// MARK: - Protocol Implementation

public extension NotificationType {
    
    var description: String {
        
        var description = "Name: \(name), Domain: \(domain)"
        
        if userInfo != nil {
            
            description += " UserInfo: \(userInfo!)"
        }
        
        return description
    }
}

// MARK: - Implementation

public struct Notification<T: AnyObject>: NotificationType {
    
    public let name: String
    
    public let domain: String
    
    public let sender: T?
    
    public let userInfo: [String: Any]?
    
    public init(name: String, domain: String, userInfo: [String: Any]? = nil, sender: T? = nil) {
        
        self.name = name
        self.domain = domain
        self.userInfo = userInfo
        self.sender = sender
    }
}