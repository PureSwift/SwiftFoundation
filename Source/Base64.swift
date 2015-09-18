//
//  Base64.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import b64

/// [Base64](https://en.wikipedia.org/wiki/Base64) encoding.
public struct Base64 {
    
    static public func decode(bytes: Data) -> Data {
        
        guard bytes.count > 0 else { return bytes }
        
        var decodeState = base64_decodestate()
        
        base64_init_decodestate(&decodeState)
        
        let inputCharArray: [CChar] = bytes.map { (element: Byte) -> CChar in return CChar(element) }
        
        // http://stackoverflow.com/questions/13378815/base64-length-calculation
        let outputBufferSize = ((inputCharArray.count * 3) / 4)
        
        let outputBuffer = UnsafeMutablePointer<CChar>.alloc(outputBufferSize)
        
        defer { outputBuffer.dealloc(outputBufferSize) }
        
        let outputBufferCount = base64_decode_block(inputCharArray, CInt(inputCharArray.count), outputBuffer, &decodeState)
        
        var outputBytes = Data()
        
        for index in 0...Int(outputBufferCount - 1) {
            
            let char = outputBuffer[index]
            
            let byte = unsafeBitCast(char, Byte.self)
            
            outputBytes.append(byte)
        }
        
        return outputBytes
    }
    
    /// Use the Base64 algorithm as decribed by RFC 4648 section 4 to
    /// encode the input bytes.
    ///
    /// :param: bytes Bytes to encode.
    /// :returns: Base64 encoded ASCII bytes.
    static public func encode(bytes: Data) -> Data {
        
        guard bytes.count > 0 else { return bytes }
        
        var encodeState = base64_encodestate()
        
        base64_init_encodestate(&encodeState)
        
        let inputCharArray: [CChar] = bytes.map { (byte) -> CChar in return unsafeBitCast(byte, CChar.self) }
        
        // http://stackoverflow.com/questions/13378815/base64-length-calculation
        let outputBufferSize = (inputCharArray.count / 3) * 4 // 4*(n/3)
        
        let outputBuffer = UnsafeMutablePointer<CChar>.alloc(outputBufferSize)
        
        defer { outputBuffer.dealloc(outputBufferSize) }
        
        let outputBufferCount = base64_encode_block(inputCharArray, CInt(inputCharArray.count), outputBuffer, &encodeState)
        
        var outputBytes = Data()
        
        for index in 0...Int(outputBufferCount - 1) {
            
            let char = outputBuffer[index]
            
            let byte = unsafeBitCast(char, Byte.self)
            
            outputBytes.append(byte)
        }
        
        return outputBytes
    }
}
