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
        
        public var URL: String
        
        public var timeoutInterval: TimeInterval = 30
        
        public var body: Data?
        
        public var headers = [String: String]()
        
        public var method: HTTP.Method = .GET
        
        public var version: HTTP.Version = HTTP.Version()
        
        public init(URL: String) {
            
            self.URL = URL
        }
    }
}

