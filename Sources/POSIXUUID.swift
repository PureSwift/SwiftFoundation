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
    public typealias POSIXUUIDStringType = uuid_string_t
#elseif os(Linux)
    public typealias POSIXUUIDStringType = (Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8)
#endif

public func POSIXUUIDCreateRandom() -> uuid_t {
    
    var uuid = uuid_t(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
    
    withUnsafeMutablePointer(&uuid, { (valuePointer: UnsafeMutablePointer<uuid_t>) -> Void in
        
        let bufferType = UnsafeMutablePointer<UInt8>.self
        
        let buffer = unsafeBitCast(valuePointer, bufferType)
        
        uuid_generate(buffer)
    })
    
    return uuid
}

public func POSIXUUIDConvertToString(uuid: uuid_t) -> String {
    
    let uuidString = POSIXUUIDConvertToUUIDString(uuid)
    
    return POSIXUUIDStringConvertToString(uuidString)
}

public func POSIXUUIDConvertToUUIDString(uuid: uuid_t) -> POSIXUUIDStringType {
    
    var uuidCopy = uuid
    
    var uuidString = POSIXUUIDStringType(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    
    withUnsafeMutablePointers(&uuidCopy, &uuidString) { (uuidPointer: UnsafeMutablePointer<uuid_t>, uuidStringPointer: UnsafeMutablePointer<POSIXUUIDStringType>) -> Void in
        
        let stringBuffer = unsafeBitCast(uuidStringPointer, UnsafeMutablePointer<Int8>.self)
        
        let uuidBuffer = unsafeBitCast(uuidPointer, UnsafeMutablePointer<UInt8>.self)
        
        uuid_unparse(unsafeBitCast(uuidBuffer, UnsafePointer<UInt8>.self), stringBuffer)
    }
    
    return uuidString
}

public func POSIXUUIDStringConvertToString(uuidString: POSIXUUIDStringType) -> String {
    
    var uuidStringCopy = uuidString
    
    return withUnsafeMutablePointer(&uuidStringCopy, { (valuePointer: UnsafeMutablePointer<POSIXUUIDStringType>) -> String in
        
        let bufferType = UnsafeMutablePointer<CChar>.self
        
        let buffer = unsafeBitCast(valuePointer, bufferType)
        
        return String.fromCString(unsafeBitCast(buffer, UnsafePointer<CChar>.self))!
    })
}

public func POSIXUUIDConvertStringToUUID(string: String) -> uuid_t? {
    
    let uuidPointer = UnsafeMutablePointer<uuid_t>.alloc(1)
    defer { uuidPointer.dealloc(1) }
    
    guard uuid_parse(string, unsafeBitCast(uuidPointer, UnsafeMutablePointer<UInt8>.self)) != -1 else {
        
        return nil
    }
    
    return uuidPointer.memory
}