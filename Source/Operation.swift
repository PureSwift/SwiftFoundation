//
//  Operation.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

// MARK: - Protocol

/** Operation Interface. Abstraction for tasks. To be used with a operation queue. */
public protocol Operation {
    
    // MARK: Properties
    
    /** The state of the operation. */
    var state: OperationState { get }
    
    /** The operations that have to be executed first before the operation can begin executing. */
    var dependencies: [Operation] { get }
    
    /** The name of the operation. (for debugging purposes) */
    var name: String?  { get }
    
    /** The priority this operation will have on a queue. */
    var queuePriority: OperationQueuePriority { get }
    
    /** The block to be executed when the operation finishes. */
    var completionBlock: (() -> Void)? { get }
    
    /** Whether the ```func main()``` function is executed syncronously or asyncronously on the queue. */
    var asynchronous: Bool { get }
    
    // MARK: Methods
    
    /** The method implementing the task to be performed by the operation. */
    func main()
}

// MARK: - Supporting Types

/** Defines the state of an operation. */
public enum OperationState {
    
    case Ready
    case Executing
    case Finished
    case Cancelled
    
    init() { self = .Ready }
}

/** The priority of an operation on a queue. */
public enum OperationQueuePriority: Int {
    
    case VeryLow    = -2
    case Low        = -1
    case Normal     =  0
    case High       =  1
    case VeryHigh   =  2
    
    init() { self = .Normal }
}

