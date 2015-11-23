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
    
    static func optionsBitmask<S: SequenceType where S.Generator.Element == Self>(options: S) -> Self.RawValue {
        return options.reduce(0) { mask, option in
            mask | option.rawValue
        }
    }
}

public extension SequenceType where Self.Generator.Element: BitMaskOption, Self.Generator.Element.RawValue: IntegerType {
    
    func optionsBitmask() -> Self.Generator.Element.RawValue {
        
        let array = self.filter { (_) -> Bool in return true }
        
        return Self.Generator.Element.optionsBitmask(array)
    }
}