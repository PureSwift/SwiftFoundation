//
//  OperationQueue.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

// MARK: - Protocol

public protocol OperationQueueType {
    
    /** The operation queue for the main thread. */
    static var mainQueue: Self { get }
    
    
}