//
//  Operation.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

/** Operation Interface. Abstraction for tasks. To be used with a operation queue. */
public protocol OperationType {
    
    // MARK: Properties
    
    var state: OperationState { get }
    
    var dependencies: [OperationType] { get }
    
    var name: String?  { get }
    
    var queuePriority: OperationQueuePriority { get }
        
    var completionBlock: (() -> Void)? { get }
    
    var asynchronous: Bool { get }
    
    // MARK: Methods
    
    func start()
    
    func cancel()
    
    func main()
    
    func addDependency(OperationType)
    
    func removeDependency(OperationType)
}

// MARK: - Implementation

/** Abstract class for operations that can be added to an operation queue. */
public class Operation: OperationType {
    
    // MARK: Properties
    
    private(set) public var state = OperationState()
    
    private(set) public var dependencies = [OperationType]()
    
    public let name: String?
    
    public let queuePriority: OperationQueuePriority
    
    public let asynchronous: Bool
    
    public let completionBlock: (() -> Void)?
    
    // MARK: Initialization
    
    public init(name: String? = nil,
        queuePriority: OperationQueuePriority = .Normal,
        asynchronous: Bool = true,
        completionBlock: (() -> Void)? = nil) {
            
            self.name = name
            self.queuePriority = queuePriority
            self.asynchronous = asynchronous
            self.completionBlock = completionBlock
    }
    
    // MARK: Methods
    
    final public func start() {
        
        self.state = OperationState.Executing
    }
    
    final public func cancel() {
        
        self.state
    }
    
    final public func addDependency(operation: OperationType) {
        
        self.dependencies.append(operation)
    }
    
    final public func removeDependency(operation: OperationType) {
        
        if let index = self.dependencies.indexOf { (operation: Operation) -> Bool in
            
            operation == operation
        } {
            
            
        }
    }
    
    public func main() {
        
        debugPrint("Executed an Operation (\(self)), which is an abstract class and does nothing. ")
    }
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

