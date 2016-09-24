//
//  String.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/5/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension String {
    
    init?(UTF8Data: Data) {
        
        let data = UTF8Data
        
        var string = ""
        
        var generator = data.makeIterator()
        
        var encoding = UTF8()
        
        repeat {
            
            switch encoding.decode(&generator) {
                
            case let .scalarValue(scalar):
                
                let scalarString = String(scalar)
                
                string.append(scalarString)
                
            case .emptyInput:
                
                self = string
                
                return
                
            case .error:
                
                return nil
            }
            
        } while true
        
        return nil
    }
    
    func toUTF8Data() -> Data {
        
        return Data(bytes: Array(utf8))
    }
    
    func substring(range: Range<Int>) -> String? {
        let indexRange = utf8.index(utf8.startIndex, offsetBy: range.lowerBound) ..< utf8.index(utf8.startIndex, offsetBy: range.upperBound)
        return String(utf8[indexRange])
    }
}
