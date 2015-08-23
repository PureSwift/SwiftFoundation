//
//  Base64.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//
//  Encoder Algorithm by Doug Richardson https://github.com/drichardson/SwiftyBase64

import b64

public struct Base64 {
    
    static public func decode(bytes: [UInt8]) -> [UInt8] {
        
        var decodeState = base64_decodestate()
        
        base64_init_decodestate(&decodeState)
        
        let outputBufferSize = bytes.count
        
        let outputBuffer = UnsafeMutablePointer<CChar>.alloc(outputBufferSize)
        
        let inputString = String.fromCString(unsafeBitCast(bytes, UnsafePointer<CChar>.self))!
        
        let outputBytesCount = base64_decode_block(inputString, CInt(strlen(inputString)), outputBuffer, &decodeState)
        
        let outputString = String.fromCString(outputBuffer)!
        
        var outputBytes: Data = outputString.utf8.map { (element: UTF8.CodeUnit) -> Byte in
            
            return element as Byte
        }
        
        assert(outputBytes.count == Int(outputBytesCount))
        
        return outputBytes
    }
    
    /// Base64 Alphabet to use during encoding.
    public enum Alphabet {
        
        /// The standard Base64 encoding, defined in RFC 4648 section 4.
        case Standard
        
        /// The ```base64url``` encoding, defined in RFC 4648 section 5.
        case URLAndFilenameSafe
    }
    
    /// Get the encoding table for the alphabet.
    static private func tableForAlphabet(alphabet : Alphabet) -> [UInt8] {
        
        switch alphabet {
            
        case .Standard:
            return StandardAlphabet
        case .URLAndFilenameSafe:
            return URLAndFilenameSafeAlphabet
        }
    }
    
    /// Use the Base64 algorithm as decribed by RFC 4648 section 4 to
    /// encode the input bytes. The alphabet specifies the translation
    /// table to use. RFC 4648 defines two such alphabets:
    ///
    /// - Standard (section 4)
    /// - URL and Filename Safe (section 5)
    ///
    /// :param: bytes Bytes to encode.
    /// :param: alphabet The Base64 alphabet to encode with.
    /// :returns: Base64 encoded ASCII bytes.
    static public func encode(bytes: [UInt8], alphabet : Alphabet = .Standard) -> [UInt8] {
        var encoded : [UInt8] = []
        
        var b = bytes[0..<bytes.count]
        
        //
        let table = tableForAlphabet(alphabet)
        let padding = table[64]
        
        for ; b.count >= 3; b = b[3..<b.count] {
            let one = b[0] >> 2
            let two = ((b[0] & 0b11) << 4) | ((b[1] & 0b11110000) >> 4)
            let three = ((b[1] & 0b00001111) << 2) | ((b[2] & 0b11000000) >> 6)
            let four = b[2] & 0b00111111
            
            encoded.append(table[Int(one)])
            encoded.append(table[Int(two)])
            encoded.append(table[Int(three)])
            encoded.append(table[Int(four)])
        }
        
        if b.count == 2 {
            // (3) The final quantum of encoding input is exactly 16 bits; here, the
            // final unit of encoded output will be three characters followed by
            // one "=" padding character.
            let one = b[0] >> 2
            let two = ((b[0] & 0b11) << 4) | ((b[1] & 0b11110000) >> 4)
            let three = ((b[1] & 0b00001111) << 2)
            encoded.append(table[Int(one)])
            encoded.append(table[Int(two)])
            encoded.append(table[Int(three)])
            encoded.append(padding)
        } else if b.count == 1 {
            // (2) The final quantum of encoding input is exactly 8 bits; here, the
            // final unit of encoded output will be two characters followed by
            // two "=" padding characters.
            let one = b[0] >> 2
            let two = ((b[0] & 0b11) << 4)
            encoded.append(table[Int(one)])
            encoded.append(table[Int(two)])
            encoded.append(padding)
            encoded.append(padding)
        } else {
            // (1) The final quantum of encoding input is an integral multiple of 24
            // bits; here, the final unit of encoded output will be an integral
            // multiple of 4 characters with no "=" padding.
            assert(b.count == 0)
        }
        
        return encoded
    }
}

// MARK: - Encoding Tables

// Note the tables contain 65 characters: 64 to do the translation and 1 more for the padding
// character used in each alphabet.

/// Standard Base64 encoding table.
private let StandardAlphabet : [UInt8] = [
    65, // 0=A
    66, // 1=B
    67, // 2=C
    68, // 3=D
    69, // 4=E
    70, // 5=F
    71, // 6=G
    72, // 7=H
    73, // 8=I
    74, // 9=J
    75, // 10=K
    76, // 11=L
    77, // 12=M
    78, // 13=N
    79, // 14=O
    80, // 15=P
    81, // 16=Q
    82, // 17=R
    83, // 18=S
    84, // 19=T
    85, // 20=U
    86, // 21=V
    87, // 22=W
    88, // 23=X
    89, // 24=Y
    90, // 25=Z
    97, // 26=a
    98, // 27=b
    99, // 28=c
    100, // 29=d
    101, // 30=e
    102, // 31=f
    103, // 32=g
    104, // 33=h
    105, // 34=i
    106, // 35=j
    107, // 36=k
    108, // 37=l
    109, // 38=m
    110, // 39=n
    111, // 40=o
    112, // 41=p
    113, // 42=q
    114, // 43=r
    115, // 44=s
    116, // 45=t
    117, // 46=u
    118, // 47=v
    119, // 48=w
    120, // 49=x
    121, // 50=y
    122, // 51=z
    48, // 52=0
    49, // 53=1
    50, // 54=2
    51, // 55=3
    52, // 56=4
    53, // 57=5
    54, // 58=6
    55, // 59=7
    56, // 60=8
    57, // 61=9
    43, // 62=+
    47, // 63=/
    // PADDING FOLLOWS, not used during lookups
    61, // 64==
]

/// URL and Filename Safe Base64 encoding table.
private let URLAndFilenameSafeAlphabet : [UInt8] = [
    65, // 0=A
    66, // 1=B
    67, // 2=C
    68, // 3=D
    69, // 4=E
    70, // 5=F
    71, // 6=G
    72, // 7=H
    73, // 8=I
    74, // 9=J
    75, // 10=K
    76, // 11=L
    77, // 12=M
    78, // 13=N
    79, // 14=O
    80, // 15=P
    81, // 16=Q
    82, // 17=R
    83, // 18=S
    84, // 19=T
    85, // 20=U
    86, // 21=V
    87, // 22=W
    88, // 23=X
    89, // 24=Y
    90, // 25=Z
    97, // 26=a
    98, // 27=b
    99, // 28=c
    100, // 29=d
    101, // 30=e
    102, // 31=f
    103, // 32=g
    104, // 33=h
    105, // 34=i
    106, // 35=j
    107, // 36=k
    108, // 37=l
    109, // 38=m
    110, // 39=n
    111, // 40=o
    112, // 41=p
    113, // 42=q
    114, // 43=r
    115, // 44=s
    116, // 45=t
    117, // 46=u
    118, // 47=v
    119, // 48=w
    120, // 49=x
    121, // 50=y
    122, // 51=z
    48, // 52=0
    49, // 53=1
    50, // 54=2
    51, // 55=3
    52, // 56=4
    53, // 57=5
    54, // 58=6
    55, // 59=7
    56, // 60=8
    57, // 61=9
    45, // 62=-
    95, // 63=_
    // PADDING FOLLOWS, not used during lookups
    61, // 64==
]