//: SwiftFoundation Introduction
//:
//: On Xcode, make sure you compile the ```SwiftFoundation OS X``` target first.

import SwiftFoundation

var str = "Hello, SwiftFoundation"

//: SwiftFoundation is a Cross-Platform, Protocol-Oriented Programming base library to complement the Swift Standard Library.
//: You can use it in places where Apple's Foundation library is unavailible (e.g. Linux)

let randomUUID = UUID()

randomUUID.rawValue

//: SwiftFoundation aims to provide the a similar *interface* and *implementation* as Foundation, but upgraded for Swift and adopting Protocol-Oriented Programming where feasible.

import Foundation

let validRawUUID = "7ADBFDE5-0311-441F-AA77-CC7BBECFA949"

let uuid = UUID(rawValue: validRawUUID)!

let foundationUUID = NSUUID(UUIDString: validRawUUID)!

uuid.rawValue == foundationUUID.UUIDString

1.compare(2)

("a" as NSString).compare("b" as String).rawValue

NSComparisonResult.OrderedAscending.rawValue

NSComparisonResult.OrderedDescending.rawValue

NSComparisonResult.OrderedSame.rawValue


