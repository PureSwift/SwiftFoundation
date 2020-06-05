//
//  Integer.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/4/20.
//

internal extension FixedWidthInteger {
    
    static var random: Self {
        return .random(in: .min ... .max)
    }
}
