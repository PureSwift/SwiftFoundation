//: Playground - noun: a place where people can play

import SwiftFoundation
import SwiftFoundationAppleBridge
import Foundation

let googleData = NSData(contentsOfURL: NSURL(string: "http://google.com")!)!

let data: Data = [0x01, 0x02]

extension NSData {
    
    public convenience init(bytes: Data) {
        self.init(bytes: bytes, length: bytes.count)
    }
    
    public func arrayOfBytes() -> Data {
        let count = self.length / sizeof(UInt8)
        var bytesArray = [UInt8](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(UInt8))
        return bytesArray
    }
}

func DataWithPointer(pointer: UnsafePointer<Void>, count: UInt) -> Data {
    
    
}