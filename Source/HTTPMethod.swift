//
//  HTTPMethod.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension HTTP {
    
    /// HTTP Method.
    public enum Method: String {
        
        case GET = "GET"
        case PUT = "PUT"
        case DELETE = "DELETE"
        case POST = "POST"
        case OPTIONS = "OPTIONS"
        case HEAD = "HEAD"
        case TRACE = "TRACE"
        case CONNECT = "CONNECT"
        case PATCH = "PATCH"
        
        init() { self = .GET }
    }
}

