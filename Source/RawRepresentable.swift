//
//  RawRepresentable.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

// MARK: - Convert Array of RawRepresentables

public extension RawRepresentable {
    
    /// Creates a collection of ```RawRepresentable``` from a collection of raw values. Returns ```nil``` if an element in the array had an invalid raw value.
    static func fromRawValues(rawValues: [RawValue]) -> [Self]? {
        
        var representables = [Self]()
        
        for element in rawValues {
            
            guard let rawRepresentable = self.init(rawValue: element) else {
                
                return nil
            }
            
            representables.append(rawRepresentable)
        }
        
        return representables
    }
}

public extension CollectionType where Self.Generator.Element: RawRepresentable {
    
    /// Converts a collection of ```RawRepresentable``` to its raw values.
    var rawValues: [Self.Generator.Element.RawValue] {
        
        typealias rawValueType = Self.Generator.Element.RawValue
        
        var rawValues = [rawValueType]()
        
        for rawRepresentable in self {
            
            rawValues.append(rawRepresentable.rawValue)
        }
        
        return rawValues
    }
}

// MARK: - SwiftFoundation Default Implementations

// MARK: CustomStringConvertible

public extension RawRepresentable {
    
    // Prints the raw value by default
    var description: String {
        
        return "\(rawValue)"
    }
}

// MARK: - Operator Overloading

// MARK: Equatable

public func == <T where T: RawRepresentable, T.RawValue: Equatable>(lhs: T, rhs: T) -> Bool {
    
    return lhs.rawValue == rhs.rawValue
}

// MARK: Comparable

public func < <T where T: RawRepresentable, T.RawValue: Comparable>(lhs: T, rhs: T) -> Bool {
    
    return lhs.rawValue < rhs.rawValue
}

public func <= <T where T: RawRepresentable, T.RawValue: Comparable>(lhs: T, rhs: T) -> Bool {
    
    return lhs.rawValue <= rhs.rawValue
}

public func >= <T where T: RawRepresentable, T.RawValue: Comparable>(lhs: T, rhs: T) -> Bool {
    
    return lhs.rawValue >= rhs.rawValue
}

public func > <T where T: RawRepresentable, T.RawValue: Comparable>(lhs: T, rhs: T) -> Bool {
    
    return lhs.rawValue > rhs.rawValue
}

