//
//  HTTPResponse.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/** HTTP URL response. */
public struct HTTPResponse: URLResponse {
    
    /** Returns a dictionary containing all the HTTP header fields. */
    public var headers: [String: String] = [:]
    
    /** Returns the HTTP status code for the response. */
    public var statusCode: Int = 0
    
    /** The HTTP response body. */
    public var body: Data = []
    
    public init() { }
}