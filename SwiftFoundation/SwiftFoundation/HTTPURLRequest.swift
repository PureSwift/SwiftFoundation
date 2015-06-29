//
//  HTTPURLRequest.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public struct HTTPURLRequest: URLRequest {
    
    public let URL: SwiftFoundation.URL
    
    public let timeoutInterval: TimeInterval
    
    public let body: Data
    
    public let headers: [String: String]
    
    public init(URL: SwiftFoundation.URL, timeoutInterval: TimeInterval, body: Data, headers: [String: String]) {
        
        self.URL = URL
        self.timeoutInterval = timeoutInterval
        self.body = body
        self.headers = headers
    }
}