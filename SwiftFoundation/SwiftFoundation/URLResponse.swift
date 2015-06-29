//
//  URLResponse.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Encapsulates the metadata associated with the response to a a URL load request in a manner independent of protocol and URL scheme.
public protocol URLResponse {
    
    /** The response body. */
    var body: Data? { get }
    
    
}