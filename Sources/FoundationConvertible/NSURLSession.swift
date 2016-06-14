//
//  NSURLSession.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 10/2/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(Linux)
    import SwiftFoundation
#endif

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import Foundation

public extension Foundation.URLRequest {
    
    init?(request: HTTP.Request) {
        
        guard let url = NSURL(string: request.URL) else { return nil }
                
        guard request.version == HTTP.Version(1, 1) else { return nil }
        
        self.init(url: url as Foundation.URL, timeoutInterval: request.timeoutInterval)
        
        if let data = request.body {
            
            self.httpBody = data.toFoundation() as Foundation.Data
        }
        
        self.allHTTPHeaderFields = request.headers
        
        self.httpMethod = request.method.rawValue
    }
}

#endif
