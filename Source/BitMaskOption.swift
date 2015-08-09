//
//  BitMaskOption.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Bit mask that represents various options
public protocol BitMaskOption: RawRepresentable {
    
    static func optionsBitmask(options: [Self]) -> Self.RawValue
}

public extension BitMaskOption where Self.RawValue: IntegerType {
    
    static func optionsBitmask(options: [Self]) -> Self.RawValue {
        
        var mask: Self.RawValue = 0
        
        for option in options {
            
            mask = mask | option.rawValue
        }
        
        return mask
    }
}

public extension CollectionType where Self.Generator.Element: BitMaskOption, Self.Generator.Element.RawValue: IntegerType {
    
    func optionsBitmask() -> Self.Generator.Element.RawValue {
        
        let array = self.filter { (_) -> Bool in return true }
        
        return Self.Generator.Element.optionsBitmask(array)
    }
}