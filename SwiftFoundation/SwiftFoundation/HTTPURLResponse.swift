//
//  HTTPURLResponse.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** HTTP URL response. */
public struct HTTPURLResponse: URLResponse {
    
    /** Returns a dictionary containing all the HTTP header fields. */
    public let headers: [String: String]
    
    /** Returns the HTTP status code for the response. */
    public let statusCode: Int
    
    /** The HTTP response body. */
    public let body: Data?
    
    public init(headers: [String: String], statusCode: Int) {
        
        self.headers = headers
        self.statusCode = statusCode
    }
}