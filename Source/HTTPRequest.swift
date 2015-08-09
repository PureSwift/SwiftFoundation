//
//  HTTPRequest.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension HTTP.Client {
    
    /** HTTP URL request. */
    public struct Request: URLRequest {
        
        public var URL: SwiftFoundation.URL
        
        public var timeoutInterval: TimeInterval = 30
        
        public var body: Data?
        
        public var headers = [String: String]()
        
        public var method: HTTP.Method = .GET
        
        public var version: HTTP.Version = HTTP.Version()
        
        public init(URL: SwiftFoundation.URL) {
            
            self.URL = URL
        }
    }
}

