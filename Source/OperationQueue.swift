//
//  OperationQueue.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

public protocol OperationQueueType: class {
    
    /** The operation queue for the main thread. */
    static var mainQueue: Self { get }
    
    var name: String { get }
}

// MARK: - Implementation

/*
final public class OperationQueue: OperationQueueType, ByteValue {
    
    public let byteValue: dispatch_queue_t
    
    public init(byteValue: dispatch_queue_t, name: String) {
        
        self.byteValue = byteValue;
    }
}
*/