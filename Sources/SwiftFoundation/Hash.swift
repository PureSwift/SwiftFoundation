//
//  Hash.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/30/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

/// Function for hashing data. 
public func Hash(_ data: Data) -> Int {
    
    // more expensive than casting but that's not safe for large values.
    return data.bytes.map({ Int($0) }).reduce(0, { $0.0 ^ $0.1 })
}
