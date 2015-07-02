//: Playground - noun: a place where people can play

import SwiftFoundation
import Foundation

var test = 42
withUnsafePointer(&test, { (ptr: UnsafePointer<Int>) -> Void in
    var voidPtr: UnsafePointer<Void> = unsafeBitCast(ptr, UnsafePointer<Void>.self)
    
    
})

private func UUIDCreateRandom() -> uuid_t {
    
    var uuid = uuid_t(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
    
    withUnsafeMutablePointer(&uuid, { (valuePointer: UnsafeMutablePointer<uuid_t>) -> Void in
        
        let bufferType = UnsafeMutablePointer<UInt8>.self
        
        let buffer = unsafeBitCast(valuePointer, bufferType)
        
        uuid_generate(buffer)
    })
    
    return uuid
}

public extension NSUUID {
    
    public var byteValue: uuid_t {
        
        var uuid = uuid_t(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
        
        withUnsafeMutablePointer(&uuid, { (valuePointer: UnsafeMutablePointer<uuid_t>) -> Void in
            
            let bufferType = UnsafeMutablePointer<UInt8>.self
            
            let buffer = unsafeBitCast(valuePointer, bufferType)
            
            self.getUUIDBytes(buffer)
        })
        
        return uuid
    }
    
    convenience init(byteValue: uuid_t) {
        
        var value = byteValue
        
        let buffer = withUnsafeMutablePointer(&value, { (valuePointer: UnsafeMutablePointer<uuid_t>) -> UnsafeMutablePointer<UInt8> in
            
            let bufferType = UnsafeMutablePointer<UInt8>.self
            
            return unsafeBitCast(valuePointer, bufferType)
        })
        
        self.init(UUIDBytes: buffer)
    }
}




let bytes = NSUUID().byteValue

let copy = NSUUID(byteValue: bytes)

copy.UUIDString





