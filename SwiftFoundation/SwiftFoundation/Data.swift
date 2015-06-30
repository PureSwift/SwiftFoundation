//
//  Data.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

#if os(osx) || os(ios) || os(watchos)
import Foundation
#endif

/** Class to hold data. */
public protocol Data {
    
    // MARK: - Properties
    
    var bytes: [UInt8] { get }
}