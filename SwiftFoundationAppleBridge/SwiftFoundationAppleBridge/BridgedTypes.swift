//
//  BridgedTypes.swift
//  SwiftFoundationAppleBridge
//
//  Created by Alsey Coleman Miller on 7/4/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

import Foundation
import SwiftFoundation
import SwiftFoundationAppleBridge

/** Declares all the types that can be bridged toll-free. This file needs to built with the targeted module since extensions that conform to protocols cannot be declared ```public```. */

//extension NSData: DataType {}
extension NSDate: DateType {}
//extension NSUUID: UUIDType {}
