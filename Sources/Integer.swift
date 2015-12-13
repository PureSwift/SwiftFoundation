//
//  Integer.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension Int64 {
    
    func toInt() -> Int? {
        
        // Can't convert to Int if the stored value is larger than the max value of Int
        guard self <= Int64(Int.max) else { return nil }
        
        return Int(self)
    }
}

public extension Int {
    
    func toInt64() -> Int64 {
        
        return Int64(self)
    }
}

public extension UnsignedIntegerType {
    
    /// Build bit pattern from array of bits.
    init(bits: [Bit]) {
    
        var bitPattern: Self = 0
        for (idx,b) in bits.enumerate() {
            if (b == Bit.One) {
                let bit = Self(UIntMax(1) << UIntMax(idx))
                bitPattern = bitPattern | bit
            }
        }
        
        self = bitPattern
    }
}

public extension Byte {
    
    /// Array of bits
    var bits: [Bit] {
        let totalBitsCount = sizeofValue(self) * 8
        
        var bitsArray = [Bit](count: totalBitsCount, repeatedValue: Bit.Zero)
        
        for j in 0..<totalBitsCount {
            let bitVal:UInt8 = 1 << UInt8(totalBitsCount - 1 - j)
            let check = self & bitVal
            
            if (check != 0) {
                bitsArray[j] = Bit.One;
            }
        }
        return bitsArray
    }
}


