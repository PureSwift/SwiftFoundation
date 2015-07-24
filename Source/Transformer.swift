//
//  Transformer.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/** Used to convert values from one representation to another. */
public protocol Transformer {
    
    typealias OriginalValueType
    
    typealias TransformedValueType
    
    func transformedValue(value: OriginalValueType) -> TransformedValueType
}

/** Transformer that allows reverse transformation. */
public protocol ReverseTransformer: Transformer {
    
    func reverseTransformedValue(value: TransformedValueType) -> OriginalValueType
}