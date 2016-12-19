//
//  URLProtocol.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/9/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public protocol URLProtocol {
    
    /// Checks whether the URL is valid for the protocol
    static func validURL(URL: URL) -> Bool
}