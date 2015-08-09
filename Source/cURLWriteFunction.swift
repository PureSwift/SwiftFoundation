//
//  cURLWriteFunction.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import cURL

public extension cURL {
    
    public typealias WriteCallBack = curl_write_callback
    
    public static var WriteFunction: WriteCallBack { return curlWriteFunction }
    
    public final class WriteFunctionStorage {
        
        public var data = [CChar]()
        
        public init() { }
    }
}

public func curlWriteFunction(contents: UnsafeMutablePointer<Int8>, size: Int, nmemb: Int, readData: UnsafeMutablePointer<Void>) -> Int {
    
    let storage = unsafeBitCast(readData, cURL.WriteFunctionStorage.self)
    
    let realsize = size * nmemb
    
    var pointer = contents
    
    for _ in 1...realsize {
        
        let byte = pointer.memory
        
        storage.data.append(byte)
        
        pointer = pointer.successor()
    }
    
    return realsize
}