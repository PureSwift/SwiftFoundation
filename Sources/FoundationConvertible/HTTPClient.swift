//
//  HTTPClient.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 9/02/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import Foundation

// Dot notation syntax for class
public extension HTTP {
    
    /// Loads HTTP requests
    public final class Client: URLClient {
        
        public init(session: URLSession = URLSession.shared()) {
            
            self.session = session
        }
        
        /// The backing ```NSURLSession```.
        public let session: URLSession
        
        public func send(request: HTTP.Request) throws -> HTTP.Response {
            
            var dataTask: URLSessionDataTask?
            
            return try send(request: request, dataTask: &dataTask)
        }
        
        public func send(request: HTTP.Request, dataTask: inout URLSessionDataTask?) throws -> HTTP.Response {
            
            // build request... 
            
            guard let urlRequest = Foundation.URLRequest(request: request)
                else { throw Error.BadRequest }
            
            // execute request
            
            let semaphore = DispatchSemaphore(value: 0);
            
            var error: NSError?
            
            var responseData: NSData?
            
            var urlResponse: HTTPURLResponse?
            
            dataTask = self.session.dataTask(with: urlRequest) { (data: Foundation.Data?, response: Foundation.URLResponse?, responseError: NSError?) -> () in
                
                responseData = data
                
                urlResponse = response as? Foundation.HTTPURLResponse
                
                error = responseError
                
                semaphore.signal()
            }
            
            dataTask!.resume()
            
            // wait for task to finish
            
            let _ = semaphore.wait(timeout: DispatchTime.distantFuture);
            
            guard urlResponse != nil else { throw error! }
            
            var response = HTTP.Response()
            
            response.statusCode = urlResponse!.statusCode
            
            if let data = responseData where data.length > 0 {
                
                response.body = Data(foundation: data)
            }
            
            response.headers = urlResponse!.allHeaderFields as! [String: String]
            
            return response
        }
    }
}


public extension HTTP.Client {
    
    public enum Error: ErrorProtocol {
        
        /// The provided request was malformed.
        case BadRequest
    }
}

#endif

