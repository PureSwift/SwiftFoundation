//
//  cURLWriteFunction.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import cURL

public final class curlWriteFunctionStorage {
    
    public var data = [CChar]()
    
    public init() { }
}

public func curlWriteFunction(contents: UnsafeMutablePointer<Int8>, size: Int, nmemb: Int, readData: UnsafeMutablePointer<Void>) -> Int {
    
    let storage = unsafeBitCast(readData, curlWriteFunctionStorage.self)
    
    let realsize = size * nmemb
    
    var pointer = contents
    
    for _ in 1...realsize {
        
        let byte = pointer.memory
        
        storage.data.append(byte)
        
        pointer = pointer.successor()
    }
    
    return realsize
}