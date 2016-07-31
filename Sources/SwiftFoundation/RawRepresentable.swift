//
//  RawRepresentable.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

// MARK: - Convert Array of RawRepresentables

public extension RawRepresentable {
    
    /// Creates a collection of ```RawRepresentable``` from a collection of raw values. 
    /// åReturns ```nil``` if an element in the array had an invalid raw value.
    static func from(rawValues: [RawValue]) -> [Self]? {
        
        var representables = [Self]()
        
        for element in rawValues {
            
            guard let rawRepresentable = self.init(rawValue: element) else { return nil }
            
            representables.append(rawRepresentable)
        }
        
        return representables
    }
}

public extension Sequence where Self.Iterator.Element: RawRepresentable {

    /// Convertes a sequence of `RawRepresentable` to its raw values.
    var rawValues: [Self.Iterator.Element.RawValue] {
        return self.map { $0.rawValue }
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

// MARK: Comparable

public func < <T>(lhs: T, rhs: T) -> Bool where T: RawRepresentable, T.RawValue: Comparable {
    
    return lhs.rawValue < rhs.rawValue
}

public func <= <T>(lhs: T, rhs: T) -> Bool where T: RawRepresentable, T.RawValue: Comparable {
    
    return lhs.rawValue <= rhs.rawValue
}

public func >= <T>(lhs: T, rhs: T) -> Bool where T: RawRepresentable, T.RawValue: Comparable {
    
    return lhs.rawValue >= rhs.rawValue
}

public func > <T>(lhs: T, rhs: T) -> Bool where T: RawRepresentable, T.RawValue: Comparable {
    
    return lhs.rawValue > rhs.rawValue
}

