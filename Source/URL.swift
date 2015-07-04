//
//  URL.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public struct URL {
    
    let stringValue: String
    
    init?(stringValue: String) {
        
        guard stringValue.characters.count > 1 else {
            
            return nil
        }
        
        self.stringValue = stringValue
    }
}