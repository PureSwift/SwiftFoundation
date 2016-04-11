//
//  Lock.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 4/9/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
#elseif os(Linux)
    import Glibc
#endif

/// Protocol defining lock and unlock operations.
public protocol Locking {
    
    /// Block until acquiring lock.
    func lock()
    
    /// Relinquish lock.
    func unlock()
}

/// Used to coordinate the operation of multiple threads of execution within the same application. 
/// A lock object can be used to mediate access to an application’s global data or to protect a critical section of code,
/// allowing it to run atomically.
///
/// - Note: `Lock` uses POSIX threads to implement its locking behavior.
/// When sending an unlock message to a `Lock`, you must be sure that message is sent from the same thread
/// that sent the initial lock message. Unlocking a lock from a different thread can result in undefined behavior.
/// You should not use this class to implement a recursive lock. 
/// Calling the lock method twice on the same thread will lock up your thread permanently. 
/// Unlocking a lock that is not locked is considered a programmer error and should be fixed in your code.
/// The `Lock` reports such errors by printing an error message to the console when they occur.
public final class Lock: Locking {
    
    // MARK: - Properties
    
    /// You can use a name string to identify a lock within your code.
    public var name: String?
    
    private var internalMutex = pthread_mutex_t()
    
    // MARK: - Intialization
    
    deinit { pthread_mutex_destroy(&internalMutex) }
    
    public init() {
        
        pthread_mutex_init(&internalMutex, nil)
    }
    
    // MARK: - Methods
    
    /// Attempts to acquire a lock before a given time.
    ///
    /// - Discussion: The thread is blocked until the receiver acquires the lock or limit is reached.
    public func lock(before limit: Date) {
        
        assert(Date() < limit, "\(limit) must be after the current date.")
        
        guard tryLock() else {
            
            repeat { sched_yield() }
                
            while limit - Date() > 0
            
            return
        }
    }
    
    public func lock() {
        
        let errorCode = pthread_mutex_lock(&internalMutex)
        
        guard errorCode == 0 else { fatalError("Could not lock mutex. \(POSIXError(rawValue: errorCode)!)") }
    }
    
    public func unlock() {
        
        let errorCode = pthread_mutex_unlock(&internalMutex)
        
        guard errorCode == 0 else { fatalError("Could not unlock mutex. \(POSIXError(rawValue: errorCode)!)") }
    }
    
    /// Try to acquire lock and return immediately. 
    public func tryLock() -> Bool {
        
        return pthread_mutex_trylock(&internalMutex) == 0
    }
}

// MARK: - Private Types

private extension Lock {
    
    /// POSIX Mutex (`Lock`) Attribute
    private final class Attribute {
        
        // MARK: - Singletons
        
        private static let Normal = Attribute(type: .normal)
        
        private static let ErrorCheck = Attribute(type: .errorCheck)
        
        private static let Recursive = Attribute(type: .recursive)
        
        // MARK: - Properties
        
        private var internalAttribute = pthread_mutexattr_t()
        
        // MARK: - Initialization
        
        deinit { pthread_mutexattr_destroy(&internalAttribute) }
        
        private init() {
            
            pthread_mutexattr_init(&internalAttribute)
        }
        
        private convenience init(type: AttributeType) {
            
            self.init()
            
            self.type = type
        }
        
        // MARK: - Methods
        
        private var type: AttributeType {
            
            get {
                
                var typeRawValue: CInt = 0
                
                pthread_mutexattr_gettype(&internalAttribute, &typeRawValue)
                
                return AttributeType(rawValue: typeRawValue)!
            }
            
            set { pthread_mutexattr_settype(&internalAttribute, newValue.rawValue) }
        }
    }
    
    /// POSIX Mutex (`Lock`) Attribute Type
    private enum AttributeType: CInt {
        
        case normal     = 0
        case errorCheck = 1
        case recursive  = 2
        
        private init() { self = normal }
    }
}
