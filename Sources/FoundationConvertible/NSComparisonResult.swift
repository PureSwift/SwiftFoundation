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
            
        case .orderedAscending:     self = .Ascending
        case .orderedDescending:    self = .Descending
        case .orderedSame:          self = .Same
        }
    }
    
    public func toFoundation() -> NSComparisonResult {
        
        switch self {
            
        case .Ascending:     return .orderedAscending
        case .Descending:    return .orderedDescending
        case .Same:          return .orderedSame
        }
    }
}
