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

private func UUIDConvertToUUIDString(uuid: uuid_t) -> uuid_string_t {
    
    var uuidCopy = uuid
    
    var uuidString = uuid_string_t(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    
    withUnsafeMutablePointers(&uuidCopy, &uuidString) { (uuidPointer: UnsafeMutablePointer<uuid_t>, uuidStringPointer: UnsafeMutablePointer<uuid_string_t>) -> Void in
        
        let stringBuffer = unsafeBitCast(uuidStringPointer, UnsafeMutablePointer<Int8>.self)
        
        let uuidBuffer = unsafeBitCast(uuidPointer, UnsafeMutablePointer<UInt8>.self)
        
        uuid_unparse(unsafeBitCast(uuidBuffer, UnsafePointer<UInt8>.self), stringBuffer)
    }
    
    return uuidString
}

private func UUIDStringConvertToString(uuidString: uuid_string_t) -> String {
    
    return "\(as %08x-%04x-%04x-%04x-%012x)"
}

private func UUIDConvertToString(uuid: uuid_t) -> String {
    
    let uuidString = UUIDConvertToUUIDString(uuid)
    
    return UUIDStringConvertToString(uuidString)
}

let uuid = UUIDCreateRandom()

let string = UUIDConvertToString(uuid)



