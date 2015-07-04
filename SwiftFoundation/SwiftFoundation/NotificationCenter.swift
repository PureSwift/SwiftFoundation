//
//  NotificationCenter.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

/** Notification Center interface */
public protocol NotificationCenterType {
    
    static var defaultCenter: Self { get }
    
    /** Posts the notification. */
    func post(notification: NotificationType)
    
    /// Forwards the notification calling the block.
    ///
    /// - parameter: name The name of the notification.
    /// - parameter: domain The domain of the notification.
    
    func addObserver(name: String, domain: String, sender: AnyObject, queue: OperationQueueType, ())
}

// MARK: - Implementation

public struct NotificationCenter: NotificationCenterType {
    
    public let defaultCenter = NotificationCenter()
    
    
}