//
//  HTTPClient.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/20/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Loads HTTP requests
public final class HTTPClient: URLClient {
        
    public static func validURL(URL: SwiftFoundation.URL) -> Bool {
        
        guard (URL.scheme == "http" ||  URL.scheme == "https") else { return false }
        
        return true
    }
    
    public func sendRequest(request: HTTPRequest) throws -> HTTPResponse {
        
        throw POSIXError.EXDEV
    }
}