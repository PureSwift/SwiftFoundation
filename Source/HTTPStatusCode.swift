//
//  HTTPStatusCode.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension HTTP {
    
    /// The standard status codes used with the HTTP protocol.
    public enum StatusCode: UInt {
        
        case Continue                       = 100
        case SwitchingProtocols             = 101
        case Processing                     = 102
        
        case OK                             = 200
        case Created                        = 201
        case Accepted                       = 202
        case NonAuthoritativeInformation    = 203
        case NoContent                      = 204
        case ResetContent                   = 205
        case PartialContent                 = 206
        case MultiStatus                    = 207
        case AlreadyReported                = 208
        case IMUsed                         = 226
        
        case MultipleChoices                = 300
        
        init() { self = .OK }
    }
}

