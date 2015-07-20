//
//  NotificationCenter.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

/** Notification Center interface */
public protocol NotificationCenterType: class {
    
    static var defaultCenter: Self { get }
    
    /** Posts the notification. */
    func post<T: NotificationType>(notification: T)
    
    /// Forwards the notification calling the block.
    ///
    /// - parameter observer: The object whose method will be called.
    /// - parameter method: The method that will be called when the notification is posted.
    /// - parameter name: The name of the notification.
    /// - parameter domain: The domain of the notification. This should be the reverse DNS of the module sending the notification.
    /// - parameter sender: The object whose notifications will be listened to. Used for filtering so that the callback is only called when a certain object posts a matching notification.
    func addObserver<T: AnyObject, U: AnyObject, V: NotificationType>(observer: T, method: (T) -> (V) -> (), name: String, domain: String, sender: U?)
}

// MARK: - Implementation

final public class NotificationCenter: NotificationCenterType {
    
    // MARK: - Singleton
    
    public static let defaultCenter: NotificationCenter = NotificationCenter()
    
    // MARK: - Private Properties
    
    private var notificationCallbacks = [String: [Callback]]()
    
    // MARK: - Methods
    
    public func post<T: NotificationType>(notification: T) {
        
        let key = notification.domain + "." + notification.name
        
        guard let callbacks = self.notificationCallbacks[key] else {
            
            return
        }
        
        for callback in callbacks {
            
            if callback.shouldExecute {
                
                callback.execute(notification)
            }
        }
    }
    
    public func addObserver<T: AnyObject, U: AnyObject, V: NotificationType>(observer: T, method: (T) -> (V) -> (), name: String, domain: String, sender: U?) {
        
        let key = domain + "." + name
        
        var callbacks: [Callback]
        
        if let notificationCallbacks = self.notificationCallbacks[key] {
            
            callbacks = notificationCallbacks
        }
        else {
            
            callbacks = [Callback]()
        }
        
        // create callback
        
        let callback = NotificationCallback(observer: observer, sender: sender, method: method)
        
        callbacks.append(callback)

    }
    
    // MARK: - Private Methods
}

// MARK: - Private Implemenation

private protocol Callback {
    
    var shouldExecute: Bool { get }
    
    func execute<T: NotificationType>(_: T)
}

private struct NotificationCallback<T: AnyObject, U: AnyObject, V: NotificationType>: Callback {
    
    var observer: T
    
    weak var sender: U?
    
    let method: (T) -> (V) -> ()
    
    init(observer: T, sender: U?, method: (T) -> (V) -> ()) {
        
        self.observer = observer
        self.sender = sender
        self.method = method
    }
    
    var shouldExecute: Bool {
        
        return true
    }
    
    func execute<T: NotificationType>(notification: T) {
        
        let notification = notification as! V
        
        self.method(self.observer)(notification)
    }
}

