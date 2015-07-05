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

