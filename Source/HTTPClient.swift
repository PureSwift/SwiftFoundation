//
//  HTTPClient.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/20/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import cURL

// Dot notation syntax for class
public extension HTTP {
    
    /// Loads HTTP requests
    public struct Client: URLClient {
        
        public init() { }
        
        public var verbose = false
        
        public func sendRequest(request: HTTP.Request) throws -> HTTP.Response {
            
            // Only HTTP 1.1 is supported
            guard request.version == HTTP.Version(1, 1) else { throw Error.BadRequest }
            
            guard let url = request.URL.URLString else { throw Error.BadRequest }
            
            let curl = cURL()
            
            try curl.setOption(CURLOPT_VERBOSE, self.verbose)
            
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
                
            case .GET: try curl.setOption(CURLOPT_HTTPGET, true)
                
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
            
            // set response data callback
            
            let responseBodyStorage = cURL.WriteFunctionStorage()
            
            try! curl.setOption(CURLOPT_WRITEDATA, unsafeBitCast(responseBodyStorage, UnsafeMutablePointer<UInt8>.self))
            
            try! curl.setOption(CURLOPT_WRITEFUNCTION, unsafeBitCast(curlWriteFunction as curl_write_callback, UnsafeMutablePointer<UInt8>.self))
            
            let responseHeaderStorage = cURL.WriteFunctionStorage()
            
            try! curl.setOption(CURLOPT_HEADERDATA, unsafeBitCast(responseHeaderStorage, UnsafeMutablePointer<UInt8>.self))
            
            try! curl.setOption(CURLOPT_HEADERFUNCTION, unsafeBitCast(curlWriteFunction as curl_write_callback, UnsafeMutablePointer<UInt8>.self))
            
            // connect to server
            try curl.perform()
            
            let responseCode = try curl.getInfo(CURLINFO_RESPONSE_CODE) as Int
            
            var response = HTTP.Response(statusCode: responseCode)
            
            // TODO implement header parsing
            
            response.body = unsafeBitCast(responseBodyStorage.data, Data.self)
            
            return response
        }
    }
}


public extension HTTP.Client {
    
    public enum Error: ErrorType {
        
        /// The provided request was malformed.
        case BadRequest
    }
}

