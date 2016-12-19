//
//  HTTPRequest.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension HTTP {
    
    /// HTTP request. 
    public struct Request: URLRequest {
        
        public var url: URL
        
        public var timeoutInterval: TimeInterval
        
        public var body: Data
        
        public var headers: [String: String]
        
        public var method: HTTP.Method
        
        public var version: HTTP.Version
        
        public init(url: URL,
                    timeoutInterval: TimeInterval = 30,
                    body: Data = Data(),
                    headers: [String: String] = [:],
                    method: HTTP.Method = .GET,
                    version: HTTP.Version = HTTP.Version()) {
            
            self.url = url
            self.timeoutInterval = timeoutInterval
            self.body = body
            self.headers = headers
            self.method = method
            self.version = version
        }
    }
}

