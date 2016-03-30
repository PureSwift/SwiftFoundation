//
//  Transformer.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Used to convert values from one representation to another. Doesn't fail.
public protocol TransformerType {
    
    associatedtype OriginalValue
    
    associatedtype TransformedValue
    
    func transformedValue(value: OriginalValue) -> TransformedValue
}

/// Transformer that allows reverse transformation.
public protocol ReverseTransformerType: TransformerType {
    
    func reverseTransformedValue(value: TransformedValue) -> OriginalValue
}