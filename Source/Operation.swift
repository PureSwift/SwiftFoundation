//
//  Operation.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

/** Operation Interface. Abstraction for tasks. To be used with a operation queue. */
public protocol Operation {
    
    // MARK: Properties
    
    var state: OperationState { get }
    
    var dependencies: [Operation] { get }
    
    var name: String?  { get }
    
    var queuePriority: OperationQueuePriority { get }
    
    var qualityOfService: 
    
    var completionBlock: (() -> Void)? { get }
    
    // MARK: Methods
    
    func start()
    
    func cancel()
    
    func main()
    
    func addDependency(Operation)
    
    func removeDependency(Operation)
}

// MARK: - Supporting Types

public enum OperationState {
    
    case Ready
    case Executing
    case Finished
    case Cancelled
    
    init() { self = .Ready }
}

public enum OperationQueuePriority: Int {
    
    case VeryLow    = -2
    case Low        = -1
    case Normal     =  0
    case High       =  1
    case VeryHigh   =  2
    
    init() { self = .Normal }
}

