//
//  NotificationCenter.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Class for notification dispatching
final public class NotificationCenter {
    
    // MARK: - Singleton
    
    public static let defaultCenter: NotificationCenter = NotificationCenter()
    
    // MARK: - Private Properties
    
    private var notificationCallbacks = [String: [NotificationCallback]]()
    
    // MARK: - Methods
    
    /// Posts the notification.
    public func post<T>(notification: Notification<T>) {
        
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
    
    /// Forwards the notification calling the block.
    ///
    /// - parameter observer: The object whose method will be called.
    /// - parameter method: The method that will be called when the notification is posted.
    /// - parameter name: The name of the notification.
    /// - parameter domain: The domain of the notification. This should be the reverse DNS of the module sending the notification.
    /// - parameter sender: The object whose notifications will be listened to. Used for filtering so that the callback is only called when a certain object posts a matching notification.
    public func addObserver<Observer: AnyObject, Sender: AnyObject>(observer: Observer, method: (Observer) -> (Notification<Sender>) -> (), name: String, domain: String, sender: Sender? = nil) {
        
        let key = domain + "." + name
        
        var callbacks: [NotificationCallback]
        
        if let notificationCallbacks = self.notificationCallbacks[key] {
            
            callbacks = notificationCallbacks
        }
        else {
            
            callbacks = [NotificationCallback]()
        }
        
        // create callback
        
        let callback = InternalNotificationCallback(observer: observer, sender: sender, method: method)
        
        callbacks.append(callback)

    }
}

// MARK: - Private Implemenation

private protocol NotificationCallback {
    
    var shouldExecute: Bool { get }
    
    func execute<Sender>(notification: Notification<Sender>)
}

private struct InternalNotificationCallback<Observer: AnyObject, Sender: AnyObject>: NotificationCallback {
    
    let observer: Observer
    
    weak var sender: Sender?
    
    let method: (Observer) -> (Notification<Sender>) -> ()
    
    init(observer: Observer, sender: Sender?, method: (Observer) -> (Notification<Sender>) -> ()) {
        
        self.observer = observer
        self.sender = sender
        self.method = method
    }
    
    var shouldExecute: Bool {
        
        return true
    }
    
    func execute<Sender>(notification: Notification<Sender>) {
        
        //self.method(self.observer)(notification)
    }
}

