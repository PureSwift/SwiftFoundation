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

#if os(Linux) || XcodeLinux
    
    public protocol Locking {
        
        func lock()
        func unlock()
    }
    
    public final class Lock: Locking {
        
        private var mutex = UnsafeMutablePointer<pthread_mutex_t>.allocate(capacity: 1)
        
        public init() {
            pthread_mutex_init(mutex, nil)
        }
        
        deinit {
            pthread_mutex_destroy(mutex)
            mutex.deinitialize()
            mutex.deallocate(capacity: 1)
        }
        
        public func lock() {
            pthread_mutex_lock(mutex)
        }
        
        public func unlock() {
            pthread_mutex_unlock(mutex)
        }
        
        public func tryLock() -> Bool {
            return pthread_mutex_trylock(mutex) == 0
        }
        
        public var name: String?
    }
    
    extension Lock {
        private func synchronized<T>(_ closure: @noescape () -> T) -> T {
            self.lock()
            defer { self.unlock() }
            return closure()
        }
    }
    
    public final class ConditionLock: Locking {
        private var _cond = Condition()
        private var _value: Int
        private var _thread: pthread_t?
        
        public init(condition: Int = 0) {
            _value = condition
        }
        
        public func lock() {
            let _ = lockBeforeDate(Date.distantFuture)
        }
        
        public func unlock() {
            _cond.lock()
            _thread = nil
            _cond.broadcast()
            _cond.unlock()
        }
        
        public var condition: Int {
            return _value
        }
        
        public func lockWhenCondition(_ condition: Int) {
            let _ = lockWhenCondition(condition, beforeDate: Date.distantFuture)
        }
        
        public func tryLock() -> Bool {
            return lockBeforeDate(Date.distantPast)
        }
        
        public func tryLockWhenCondition(_ condition: Int) -> Bool {
            return lockWhenCondition(condition, beforeDate: Date.distantPast)
        }
        
        public func unlockWithCondition(_ condition: Int) {
            _cond.lock()
            _thread = nil
            _value = condition
            _cond.broadcast()
            _cond.unlock()
        }
        
        public func lockBeforeDate(_ limit: Date) -> Bool {
            _cond.lock()
            while _thread == nil {
                if !_cond.waitUntilDate(limit) {
                    _cond.unlock()
                    return false
                }
            }
            _thread = pthread_self()
            _cond.unlock()
            return true
        }
        
        public func lockWhenCondition(_ condition: Int, beforeDate limit: Date) -> Bool {
            _cond.lock()
            while _thread != nil || _value != condition {
                if !_cond.waitUntilDate(limit) {
                    _cond.unlock()
                    return false
                }
            }
            _thread = pthread_self()
            _cond.unlock()
            return true
        }
        
        public var name: String?
    }
    
    public final class RecursiveLock: Locking {
        private var mutex = UnsafeMutablePointer<pthread_mutex_t>.allocate(capacity: 1)
        
        public init() {
            
            var attrib = pthread_mutexattr_t()
            withUnsafeMutablePointer(&attrib) { attrs in
                pthread_mutexattr_settype(attrs, Int32(PTHREAD_MUTEX_RECURSIVE))
                pthread_mutex_init(mutex, attrs)
            }
        }
        
        deinit {
            pthread_mutex_destroy(mutex)
            mutex.deinitialize()
            mutex.deallocate(capacity: 1)
        }
        
        public func lock() {
            pthread_mutex_lock(mutex)
        }
        
        public func unlock() {
            pthread_mutex_unlock(mutex)
        }
        
        public func tryLock() -> Bool {
            return pthread_mutex_trylock(mutex) == 0
        }
        
        public var name: String?
    }
    
    public final class Condition: Locking {
        private var mutex = UnsafeMutablePointer<pthread_mutex_t>.allocate(capacity: 1)
        private var cond = UnsafeMutablePointer<pthread_cond_t>.allocate(capacity: 1)
        
        public init() {
            pthread_mutex_init(mutex, nil)
            pthread_cond_init(cond, nil)
        }
        
        deinit {
            pthread_mutex_destroy(mutex)
            pthread_cond_destroy(cond)
            mutex.deinitialize()
            cond.deinitialize()
            mutex.deallocate(capacity: 1)
            cond.deallocate(capacity: 1)
        }
        
        public func lock() {
            pthread_mutex_lock(mutex)
        }
        
        public func unlock() {
            pthread_mutex_unlock(mutex)
        }
        
        public func wait() {
            pthread_cond_wait(cond, mutex)
        }
        
        public func waitUntilDate(_ limit: Date) -> Bool {
            let lim = limit.timeIntervalSinceReferenceDate
            let ti = lim - Date.timeIntervalSinceReferenceDate
            if ti < 0.0 {
                return false
            }
            var ts = timespec()
            ts.tv_sec = Int(floor(ti))
            ts.tv_nsec = Int((ti - Double(ts.tv_sec)) * 1000000000.0)
            var tv = timeval()
            withUnsafeMutablePointer(&tv) { t in
                gettimeofday(t, nil)
                ts.tv_sec += t.pointee.tv_sec
                ts.tv_nsec += Int((t.pointee.tv_usec * 1000000) / 1000000000)
            }
            let retVal: Int32 = withUnsafePointer(&ts) { t in
                return pthread_cond_timedwait(cond, mutex, t)
            }
            
            return retVal == 0
        }
        
        public func signal() {
            pthread_cond_signal(cond)
        }
        
        public func broadcast() {
            pthread_cond_broadcast(cond)
        }
        
        public var name: String?
    }
    
#endif
