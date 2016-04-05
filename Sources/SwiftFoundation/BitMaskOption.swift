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

public extension BitMaskOption where Self.RawValue: Integer {
    
    static func optionsBitmask<S: Sequence where S.Iterator.Element == Self>(options: S) -> Self.RawValue {
        return options.reduce(0) { mask, option in
            mask | option.rawValue
        }
    }
}

public extension Sequence where Self.Iterator.Element: BitMaskOption, Self.Iterator.Element.RawValue: Integer {
    
    func optionsBitmask() -> Self.Iterator.Element.RawValue {
        
        let array = self.filter { (_) -> Bool in return true }
        
        return Self.Iterator.Element.optionsBitmask(array)
    }
}