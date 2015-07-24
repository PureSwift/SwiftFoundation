//
//  Order.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

public extension NSComparisonResult {
    
    func toOrder() -> Order {
        
        switch self {
            
        case .OrderedAscending: return .Ascending
        case .OrderedDescending: return .Descending
        case .OrderedSame: return .Same
        }
    }
}