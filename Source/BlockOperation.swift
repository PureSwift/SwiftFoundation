//
//  BlockOperation.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/5/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

public protocol BlockOperationType: Operation {
    
    var block: () -> Void { get }
}

// MARK: - Implemenation

public struct BlockOperation: BlockOperationType {
    
    // MARK: Properties
    
    public var state = OperationState()
    
    public var dependencies = [Operation]()
    
    public let name: String?
    
    public let queuePriority: OperationQueuePriority
    
    public let asynchronous: Bool
    
    public let completionBlock: (() -> Void)?
    
    public let block: () -> Void
    
    // MARK: Initialization
    
    public init(block: () -> Void,
        name: String? = nil,
        queuePriority: OperationQueuePriority = .Normal,
        asynchronous: Bool = true,
        completionBlock: (() -> Void)? = nil) {
            
            self.block = block
            self.name = name
            self.queuePriority = queuePriority
            self.asynchronous = asynchronous
            self.completionBlock = completionBlock
    }
    
    // MARK: Methods
    
    public func main() {
        
        self.block()
    }
}