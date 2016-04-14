//
//  POSIXUUID.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux)
    import Glibc
    import CUUID
#endif

// MARK: - POSIX UUID System Type Functions

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    internal typealias POSIXUUIDStringType = uuid_string_t
#elseif os(Linux)
    internal typealias POSIXUUIDStringType = (Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8)
#endif

internal func POSIXUUIDCreateRandom() -> uuid_t {
    
    var uuid = uuid_t(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
    
    withUnsafeMutablePointer(&uuid, { (valuePointer: UnsafeMutablePointer<uuid_t>) -> Void in
        
        let bufferType = UnsafeMutablePointer<UInt8>.self
        
        let buffer = unsafeBitCast(valuePointer, to: bufferType)
        
        uuid_generate(buffer)
    })
    
    return uuid
}

internal func POSIXUUIDConvertToString(_ uuid: uuid_t) -> String {
    
    let uuidString = POSIXUUIDConvertToUUIDString(uuid)
    
    return POSIXUUIDStringConvertToString(uuidString)
}

internal func POSIXUUIDConvertToUUIDString(_ uuid: uuid_t) -> POSIXUUIDStringType {
    
    var uuidCopy = uuid
    
    var uuidString = POSIXUUIDStringType(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    
    withUnsafeMutablePointers(&uuidCopy, &uuidString) { (uuidPointer: UnsafeMutablePointer<uuid_t>, uuidStringPointer: UnsafeMutablePointer<POSIXUUIDStringType>) -> Void in
        
        let stringBuffer = unsafeBitCast(uuidStringPointer, to: UnsafeMutablePointer<Int8>.self)
        
        let uuidBuffer = unsafeBitCast(uuidPointer, to: UnsafeMutablePointer<UInt8>.self)
        
        uuid_unparse(unsafeBitCast(uuidBuffer, to: UnsafePointer<UInt8>.self), stringBuffer)
    }
    
    return uuidString
}

internal func POSIXUUIDStringConvertToString(_ uuidString: POSIXUUIDStringType) -> String {
    
    var uuidStringCopy = uuidString
    
    return withUnsafeMutablePointer(&uuidStringCopy, { (valuePointer: UnsafeMutablePointer<POSIXUUIDStringType>) -> String in
        
        let bufferType = UnsafeMutablePointer<CChar>.self
        
        let buffer = unsafeBitCast(valuePointer, to: bufferType)
        
        return String(validatingUTF8: unsafeBitCast(buffer, to: UnsafePointer<CChar>.self))!
    })
}

internal func POSIXUUIDConvertStringToUUID(_ string: String) -> uuid_t? {
    
    let uuidPointer = UnsafeMutablePointer<uuid_t>(allocatingCapacity: 1)
    defer { uuidPointer.deallocateCapacity(1) }
    
    guard uuid_parse(string, unsafeBitCast(uuidPointer, to: UnsafeMutablePointer<UInt8>.self)) != -1 else {
        
        return nil
    }
    
    return uuidPointer.pointee
}
