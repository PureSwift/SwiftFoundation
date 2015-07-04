//
//  Notification.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

/** Notification type. */
public protocol NotificationType {
    
    /** The name of the notification. */
    var name: String { get }
    
    /** The notification's domain. */
    var domain: String { get }
    
    /** Accompanying payload for the notification. */
    var userInfo: [String: Any] { get }
}