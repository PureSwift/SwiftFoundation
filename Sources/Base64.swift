//
//  Base64.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/28/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//
// Encoding algorithm from https://github.com/drichardson/SwiftyBase64

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Foundation
#elseif os(Linux)
    import Cb64
#endif

/// [Base64](https://en.wikipedia.org/wiki/Base64) encoding.
public struct Base64 {
    
    // MARK: - Decoding
    
    public static func decode(bytes: Data) -> Data {
        
        #if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
            
        let encodedData = NSData(bytes: bytes)
            
        let decodedData = NSData(base64EncodedData: encodedData, options: .IgnoreUnknownCharacters)
            
        return decodedData!.arrayOfBytes()
            
        #elseif os(Linux)
        
        guard bytes.count > 0 else { return bytes }
        
        var decodeState = base64_decodestate()
        
        base64_init_decodestate(&decodeState)
        
        let inputCharArray: [CChar] = bytes.map { (element: Byte) -> CChar in return CChar(element) }
        
        // http://stackoverflow.com/questions/13378815/base64-length-calculation
        let outputBufferSize = ((inputCharArray.count * 3) / 4)
        
        let outputBuffer = UnsafeMutablePointer<CChar>.alloc(outputBufferSize)
        
        defer { outputBuffer.dealloc(outputBufferSize) }
        
        let outputBufferCount = base64_decode_block(inputCharArray, CInt(inputCharArray.count), outputBuffer, &decodeState)
        
        let outputBytes = DataFromBytePointer(outputBuffer, length: Int(outputBufferCount))
        
        return outputBytes
        
        #endif
    }
    
    // MARK: - Encoding
    
    /**
     Use the Base64 algorithm as decribed by RFC 4648 section 4 to
     encode the input bytes. The alphabet specifies the translation
     table to use. RFC 4648 defines two such alphabets:
     - Standard (section 4)
     - URL and Filename Safe (section 5)
     - parameter bytes: Bytes to encode.
     - parameter alphabet: The Base64 alphabet to encode with.
     - returns: Base64 encoded ASCII bytes.
     */
    public static func encode(bytes: Data, alphabet: Alphabet = .Standard) -> Data {
        var encoded : [UInt8] = []
        
        let table = Base64.tableForAlphabet(alphabet)
        let padding = table[64]
        
        var i = 0
        let count = bytes.count
        
        for ; i+3 <= count; i += 3 {
            let one = bytes[i] >> 2
            let two = ((bytes[i] & 0b11) << 4) | ((bytes[i+1] & 0b11110000) >> 4)
            let three = ((bytes[i+1] & 0b00001111) << 2) | ((bytes[i+2] & 0b11000000) >> 6)
            let four = bytes[i+2] & 0b00111111
            
            encoded.append(table[Int(one)])
            encoded.append(table[Int(two)])
            encoded.append(table[Int(three)])
            encoded.append(table[Int(four)])
        }
        
        if i+2 == count {
            // (3) The final quantum of encoding input is exactly 16 bits; here, the
            // final unit of encoded output will be three characters followed by
            // one "=" padding character.
            let one = bytes[i] >> 2
            let two = ((bytes[i] & 0b11) << 4) | ((bytes[i+1] & 0b11110000) >> 4)
            let three = ((bytes[i+1] & 0b00001111) << 2)
            encoded.append(table[Int(one)])
            encoded.append(table[Int(two)])
            encoded.append(table[Int(three)])
            encoded.append(padding)
        } else if i+1 == count {
            // (2) The final quantum of encoding input is exactly 8 bits; here, the
            // final unit of encoded output will be two characters followed by
            // two "=" padding characters.
            let one = bytes[i] >> 2
            let two = ((bytes[i] & 0b11) << 4)
            encoded.append(table[Int(one)])
            encoded.append(table[Int(two)])
            encoded.append(padding)
            encoded.append(padding)
        } else {
            // (1) The final quantum of encoding input is an integral multiple of 24
            // bits; here, the final unit of encoded output will be an integral
            // multiple of 4 characters with no "=" padding.
            assert(i == count)
        }
        
        return encoded
    }
}

// MARK: - Alphabet

public extension Base64 {
    
    /**
     Base64 Alphabet to use during encoding.
     - Standard: The standard Base64 encoding, defined in RFC 4648 section 4.
     - URLAndFilenameSafe: The base64url encoding, defined in RFC 4648 section 5.
     */
    public enum Alphabet {
        /// The standard Base64 alphabet
        case Standard
        
        /// The URL and Filename Safe Base64 alphabet
        case URLAndFilenameSafe
    }
}

private extension Base64 {
    
    /// Get the encoding table for the alphabet.
    static func tableForAlphabet(alphabet : Alphabet) -> [UInt8] {
        switch alphabet {
        case .Standard:
            return StandardAlphabet
        case .URLAndFilenameSafe:
            return URLAndFilenameSafeAlphabet
        }
    }
}

// The tables in this file were generated using generate_alphabet_table in the tools directory.
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
