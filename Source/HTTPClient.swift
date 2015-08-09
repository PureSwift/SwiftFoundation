//
//  HTTPClient.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/20/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import cURL

public extension HTTP {
    public typealias Client = HTTPClient
}

/// Loads HTTP requests
public struct HTTPClient: URLClient {
    
    public func sendRequest(request: HTTP.Request) throws -> HTTP.Response {
        
        // Only HTTP 1.1 is supported
        guard request.version == HTTP.Version(1, 1) else { throw Error.BadRequest }
        
        let curl = cURL()
        
        guard let url = request.URL.URLString else { throw Error.BadRequest }
        
        try curl.setOption(CURLOPT_URL, url)
        
        try curl.setOption(CURLOPT_TIMEOUT, cURL.Long(request.timeoutInterval))
        
        // append data
        if let bodyData = request.body {
            
            try curl.setOption(CURLOPT_POSTFIELDS, bodyData)
            
            try curl.setOption(CURLOPT_POSTFIELDSIZE, bodyData.count)
        }
        
        // set HTTP method
        
        switch request.method {
            
        case .HEAD:
            try curl.setOption(CURLOPT_NOBODY, true)
            try curl.setOption(CURLOPT_CUSTOMREQUEST, request.method.rawValue)
            
        case .POST:
            try curl.setOption(CURLOPT_POST, true)
            
        case .GET: break // GET is default
            
        default:
            
            try curl.setOption(CURLOPT_CUSTOMREQUEST, request.method.rawValue)
        }
        
        // set headers
        if request.headers.count > 0 {
            
            var curlHeaders = [String]()
            
            for (header, headerValue) in request.headers {
                
                curlHeaders.append(header + ": " + headerValue)
            }
            
            try curl.setOption(CURLOPT_HTTPHEADER, curlHeaders)
        }
        
        
        var response = Response(statusCode: 200)
        
        
        
        return response
    }
}

public extension HTTP.Client {
    
    public enum Error: ErrorType {
        
        /// The provided request was malformed.
        case BadRequest
    }
}