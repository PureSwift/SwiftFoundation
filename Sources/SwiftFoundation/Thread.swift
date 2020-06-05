//
//  Thread.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 4/5/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

#if !arch(wasm32)

/// POSIX Thread
public final class Thread {
    
    // MARK: - Private Properties
    
    private let internalThread: pthread_t
    
    // MARK: - Intialization
    
    public init(block: @escaping () -> ()) throws {
        
        let holder = Unmanaged.passRetained(Closure(closure: block))
        
        let pointer = holder.toOpaque()
        
        #if canImport(Glibc)
            
            var internalThread: pthread_t = 0
            
            guard pthread_create(&internalThread, nil, ThreadPrivateMain, pointer) == 0
                else { throw POSIXError.fromErrno() }
            
            self.internalThread = internalThread
            
            pthread_detach(internalThread)
            
        #elseif canImport(Darwin)
            
            var internalThread: pthread_t? = nil
            
            guard pthread_create(&internalThread, nil, ThreadPrivateMain, pointer) == 0
                else { throw POSIXError.fromErrno() }
            
            self.internalThread = internalThread!
            
            pthread_detach(internalThread!)
            
        #endif
    }
    
    // MARK: - Class Methods
    
    public static func exit(code: inout Int) {
        
        pthread_exit(&code)
    }
    
    // MARK: - Methods
    
    public func join() throws {
        
        let errorCode = pthread_join(internalThread, nil)
        
        guard errorCode == 0
            else { throw POSIXError(code: POSIXErrorCode(rawValue: errorCode)!) }
    }
    
    public func cancel() throws {
        
        let errorCode = pthread_cancel(internalThread)
        
        guard errorCode == 0
            else { throw POSIXError(code: POSIXErrorCode(rawValue: errorCode)!) }
    }
}

// MARK: - Private

#if canImport(Glibc)
    
    private func ThreadPrivateMain(arg: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
        
        let unmanaged = Unmanaged<Thread.Closure>.fromOpaque(arg!)
        
        unmanaged.takeUnretainedValue().closure()
        
        unmanaged.release()
        
        return nil
    }
    
#elseif canImport(Darwin)
    
    private func ThreadPrivateMain(arg: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer? {
        
        let unmanaged = Unmanaged<Thread.Closure>.fromOpaque(arg)
        
        unmanaged.takeUnretainedValue().closure()
        
        unmanaged.release()
        
        return nil
    }
    
#endif

fileprivate extension Thread {
    
    final class Closure {
        
        let closure: () -> ()
        
        init(closure: @escaping () -> ()) {
            
            self.closure = closure
        }
    }
}

#endif
