//
//  Data.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** Encapsulates data. */
public protocol Data {
    
    // MARK: - Properties
    
    var count: UInt { get }
    
    var bytes: UnsafePointer<Void> { get }
}

public extension Data {
    
    var isEmpty: Bool {
        
        return self.count == 0
    }
}