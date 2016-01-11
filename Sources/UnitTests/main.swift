//
//  main.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 12/16/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import XCTest

#if os(OSX) || os(iOS)
    func XCTMain(cases: [XCTestCase]) { fatalError("Not Implemented. Linux only") }
#endif

#if os(Linux)
    XCTMain([DateComponentsTest(),
        OrderTests(),
        POSIXTimeTests(),
        RegularExpressionTests(),
        SortDescriptorTests(),
        StringTests(),
        UUIDTests(),
        DataTests(),
        JSONTests()])
#endif

