//
//  HTTPClient.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 9/02/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

// Dot notation syntax for class
public extension HTTP {
    
    /// Loads HTTP requests
    public final class Client: URLClient {
        
        public init(session: NSURLSession = NSURLSession.sharedSession()) {
            
            self.session = session
        }
        
        /// The backing ```NSURLSession```.
        public let session: NSURLSession
        
        public func sendRequest(request: HTTP.Request) throws -> HTTP.Response {
            
            var dataTask: NSURLSessionDataTask?
            
            return try sendRequest(request, dataTask: &dataTask)
        }
        
        public func sendRequest(request: HTTP.Request, inout dataTask: NSURLSessionDataTask?) throws -> HTTP.Response {
            
            // build request... 
            
            guard let urlRequest = NSMutableURLRequest(request: request)
                else { throw Error.BadRequest }
            
            // execute request
            
            let semaphore = dispatch_semaphore_create(0);
            
            var error: NSError?
            
            var responseData: NSData?
            
            var urlResponse: NSHTTPURLResponse?
            
            dataTask = self.session.dataTaskWithRequest(urlRequest) { (data: NSData?, response: NSURLResponse?, responseError: NSError?) -> Void in
                
                responseData = data
                
                urlResponse = response as? NSHTTPURLResponse
                
                error = responseError
                
                dispatch_semaphore_signal(semaphore);
            }
            
            dataTask!.resume()
            
            // wait for task to finish
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            guard urlResponse != nil else { throw error! }
            
            var response = HTTP.Response()
            
            response.statusCode = urlResponse!.statusCode
            
            if let data = responseData where data.length > 0 {
                
                response.body = data.arrayOfBytes()
            }
            
            response.headers = urlResponse!.allHeaderFields as! [String: String]
            
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

