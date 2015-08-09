//
//  HTTPClient.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/20/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import cURL

/// Loads HTTP requests
public struct HTTPClient: URLClient {
    
    public func sendRequest(request: Request) throws -> Response {
        
        let curl = cURL()
        
        guard let url = request.URL.URLString else { throw Error.BadRequest }
        
        try curl.setOption(CURLOPT_URL, url)
        
        try curl.setOption(CURLOPT_TIMEOUT, cURL.Long(request.timeoutInterval))
        
        // append data
        if let bodyData = request.body {
            
            let storage = curlReadFunctionStorage(data: bodyData)
            
            try curl.setOption(CURLOPT_READFUNCTION, unsafeBitCast(curlReadFunction as curl_read_callback, UnsafePointer<UInt8>.self))
            
            try curl.setOption(CURLOPT_READDATA, unsafeBitCast(storage, UnsafePointer<UInt8>.self))
        }
        
        // set HTTP method
        
        switch request.method {
            
            
            
        default:
            
            try curl.setOption(CURLOPT_CUSTOMREQUEST, request.method.rawValue)
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