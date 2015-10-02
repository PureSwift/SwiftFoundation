//
//  NSURLSession.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 10/2/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

public extension NSMutableURLRequest {
    
    convenience init?(request: HTTP.Request) {
        
        self.init()
        
        guard request.version == HTTP.Version(1, 1) else { return nil }
        
        guard let url = NSURL(string: request.URL) else { return nil }
        
        self.URL = url
        
        self.timeoutInterval = request.timeoutInterval
        
        if let data = request.body {
            
            self.HTTPBody = NSData(bytes: data)
        }
        
        self.allHTTPHeaderFields = request.headers
        
        self.HTTPMethod = request.method.rawValue
    }
}
