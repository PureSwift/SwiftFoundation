//
//  HTTPURLProtocol.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/20/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public final class HTTPURLProtocol: URLProtocol {
    
    static func validURL(URL: SwiftFoundation.URL) -> Bool {
        
        guard (URL.scheme == "http" ||  URL.scheme == "https") else { return false }
        
        return true
    }
}