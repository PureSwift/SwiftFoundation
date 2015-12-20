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
        
        var generator = data.byteValue.generate()
        
        var encoding = UTF8()
                
        repeat {
        
            switch encoding.decode(&generator) {
                
            case .Result (let scalar):
                
                string.append(scalar)
                
            case .EmptyInput:
                
                self = string
                
                return
                
            case .Error:
                
                return nil
            }
            
        } while true
        
        return nil
    }
    
    func toUTF8Data() -> Data {
        
        return Data(byteValue: [] + utf8)
    }
}