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
        
    /** Posts the notification. */
    func post(notification: NotificationType)
    
    /// Forwards the notification calling the block.
    ///
    /// - parameter: name The name of the notification.
    /// - parameter: domain The domain of the notification. This should be the reverse DNS of the module sending the notification. 
    /// - parameter: sender The object that sent the notification. Used for filtering so that the callback is only called when a certain object posts that notification.
    /// - parameter: queue The operation queue that will be used to execute the callback closure.
    func addObserver<T: NotificationType, U: OperationQueueType, V: AnyObject>(name: String, domain: String, sender: V?, queue: U, (T) -> Void)
}

// MARK: - Implementation

final public class NotificationCenter: NotificationCenterType {
    
    public let defaultCenter: NotificationCenterType = NotificationCenter()
    
    public func post(notification: NotificationType) {
        
        
    }
    
    public func addObserver<T: NotificationType, U: OperationQueueType, V: AnyObject>(name: String, domain: String, sender: V?, queue: U, (T) -> Void) {
        
        
    }
}