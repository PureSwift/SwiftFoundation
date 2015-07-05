//
//  BlockOperation.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/5/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

public protocol BlockOperationType: OperationType {
    
    var block: () -> Void { get }
}

// MARK: - Implemenation

final public class BlockOperation: Operation, BlockOperationType {
    
    // MARK: Properties
    
    public let block: () -> Void
    
    // MARK: Initialization
    
    init(block: () -> Void,
        name: String?,
        queuePriority: OperationQueuePriority,
        asynchronous: Bool = true,
        completionBlock: (() -> Void)? = nil) {
        
            self.block = block
            
            super.init(name: name,
                queuePriority: queuePriority,
                asynchronous: asynchronous,
                completionBlock: completionBlock)
    }
    
    // MARK: Methods
    
    public override func main() {
        
        self.block()
    }
    
    
}