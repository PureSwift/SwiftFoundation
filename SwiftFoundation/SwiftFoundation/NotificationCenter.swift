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
    
    typealias NotificationType
    
    typealias OperationQueueType
    
    static var defaultCenter: Self { get }
    
    /** Posts the notification. */
    func post(notification: NotificationType)
    
    func addObserver(name: String, domain: String, queue: OperationQueueType)
}

// MARK: - Implementation

public struct NotificationCenter: NotificationCenterType {
    
    public let defaultCenter = NotificationCenter()
    
    
}