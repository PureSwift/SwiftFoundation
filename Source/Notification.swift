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
    
    /** The name of the notification. */
    var name: String { get }
    
    /** The notification's domain. */
    var domain: String { get }
    
    /** Accompanying payload for the notification. */
    var userInfo: [String: Any]? { get }
    
    /** Default initializer. */
    init(name: String, domain: String, userInfo: [String: Any]?)
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

public struct Notification: NotificationType {
    
    public let name: String
    
    public let domain: String
    
    public let userInfo: [String: Any]?
    
    public init(name: String, domain: String, userInfo: [String: Any]?) {
        
        self.name = name
        self.domain = domain
        self.userInfo = userInfo
    }
}