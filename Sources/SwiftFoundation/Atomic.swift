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
        
        get {
            
            let value: Value
            
            lock.lock()
            value = internalValue
            lock.unlock()
            
            return value
        }
        
        mutating set {
            
            ensureUnique()
            
            lock.lock()
            internalValue = newValue
            lock.unlock()
        }
    }
    
    // MARK: - Private Properties
    
    private var internalValue: Value
    
    private var lock = Lock()
    
    // MARK: - Initialization
    
    public init(_ value: Value) {
        
        self.internalValue = value
    }
    
    // MARK: - Private Methods
    
    private mutating func ensureUnique() {
        
        if !isUniquelyReferencedNonObjC(&lock) {
            lock = Lock()
        }
    }
}
