//
//  Order.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(Linux)
    import SwiftFoundation
#endif

import Foundation

extension Order: FoundationConvertible {
    
    public init(foundation: NSComparisonResult) {
        
        switch foundation {
            
        case .orderedAscending:     self = .ascending
        case .orderedDescending:    self = .descending
        case .orderedSame:          self = .same
        }
    }
    
    public func toFoundation() -> NSComparisonResult {
        
        switch self {
            
        case .ascending:     return .orderedAscending
        case .descending:    return .orderedDescending
        case .same:          return .orderedSame
        }
    }
}
