//
//  Null.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/** An OOP placeholder for ```nil```. */
public struct Null: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    public var description: String { return "<null>" }
}