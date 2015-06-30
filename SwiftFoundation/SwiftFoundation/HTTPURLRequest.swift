//
//  HTTPURLRequest.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** HTTP URL request. */
public struct HTTPURLRequest: URLRequest {
    
    public let URL: SwiftFoundation.URL
    
    public let timeoutInterval: TimeInterval
    
    public let body: Data?
    
    public let headers: [String: String]
    
    public let method: HTTPMethod
    
    public let version: HTTPVersion
    
    public init(URL: SwiftFoundation.URL,
        timeoutInterval: TimeInterval = 30,
        body: Data? = nil,
        headers: [String: String] = [:],
        method: HTTPMethod = .GET,
        version: HTTPVersion = HTTPVersion()) {
        
        self.URL = URL
        self.timeoutInterval = timeoutInterval
        self.body = body
        self.headers = headers
        self.method = method
        self.version = version
    }
}