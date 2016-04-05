//
//  Range.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 3/31/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

public extension Range where Element: Integer {
    
    func isSubset(other: Range) -> Bool {
        
        return self.startIndex >= other.startIndex
            && self.startIndex <= other.endIndex
            && self.endIndex >= other.startIndex
            && self.endIndex <= other.endIndex
    }
}