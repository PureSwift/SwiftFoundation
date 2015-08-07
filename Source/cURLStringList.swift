//
//  cURLStringList.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/5/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import cURL

public extension cURL.StringList {
    
    init(strings: [String]) {
        
        self = curl_slist()
        
        for string in strings {
            
            self.append(string)
        }
    }
    
    var value: String? { return String.fromCString(data) }
    
    mutating func append(string: String) { curl_slist_append(&self, string) }
    
    mutating func free() { curl_slist_free_all(&self) }
}