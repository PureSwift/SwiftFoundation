//
//  Order.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

extension Order: FoundationConvertible {
    
    public init(foundation: NSComparisonResult) {
        
        switch foundation {
            
        case .OrderedAscending:     self = .Ascending
        case .OrderedDescending:    self = .Descending
        case .OrderedSame:          self = .Same
        }
    }
    
    public func toFoundation() -> NSComparisonResult {
        
        switch self {
            
        case .Ascending:     return .OrderedAscending
        case .Descending:    return .OrderedDescending
        case .Same:          return .OrderedSame
        }
    }
}
