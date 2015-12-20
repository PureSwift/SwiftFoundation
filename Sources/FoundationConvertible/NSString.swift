//
//  NSString.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 12/16/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(Linux)
    import SwiftFoundation
#endif

import Foundation

extension String: FoundationConvertible {
    
    public init(foundation: NSString) {
        
        self.init("\(foundation)")
    }
    
    public func toFoundation() -> NSString {
        
        let stringData = self.toUTF8Data()
        
        guard let foundationString = NSString(bytes: stringData.byteValue, length: stringData.byteValue.count, encoding: NSUTF8StringEncoding)
            else { fatalError("Could not convert String to NSString") }
        
        return foundationString
    }
}