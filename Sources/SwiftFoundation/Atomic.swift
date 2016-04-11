//
//  Atomic.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 4/10/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

/// Encapsulates atomic values that are thread-safe.
public struct Atomic<Value> {
    
    // MARK: - Properties
    
    public var value: Value {
        
        get { return storage.value }
        
        mutating set {
            
            ensureUnique()
            storage.value = newValue
        }
    }
    
    // MARK: - Private Properties
    
    private var storage: AtomicStorage<Value>
    
    // MARK: - Initialization
    
    public init(_ value: Value) {
        
        self.storage = AtomicStorage(value)
    }
    
    // MARK: - Private Methods
    
    private mutating func ensureUnique() {
        
        if !isUniquelyReferencedNonObjC(&storage) {
            storage = storage.copy
        }
    }
}

/// Internal Storage for `Atomic`.
private final class AtomicStorage<Value> {
    
    /// Actual storage for property
    var _value: Value
    
    var value: Value {
        
        get {
            
            let value: Value
            
            lock.lock()
            value = _value
            lock.unlock()
            
            return value
        }
        
        set {
            
            lock.lock()
            _value = newValue
            lock.unlock()
        }
    }
    
    let lock = Lock()
    
    init(_ value: Value) {
        
        _value = value
    }
    
    var copy: AtomicStorage {
        
        return AtomicStorage(_value)
    }
}
