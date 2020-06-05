//
//  UUID.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// A representation of a universally unique identifier (```UUID```).
public struct UUID {
    
    // MARK: - Properties
    
    public let uuid: uuid_t
    
    // MARK: - Initialization
    
    /// Create a new UUID with RFC 4122 version 4 random bytes
    public init() {
        
        let uuid = uuid_t(.random,.random,.random,.random,.random,.random,.random,.random,.random,.random,.random,.random,.random,.random,.random,.random)
        self.init(uuid: uuid)
    }
    
    /// Create a UUID from a `uuid_t`.
    public init(uuid: uuid_t) {
        self.uuid = uuid
    }
    
    // MARK: - UUID String
    
    /// Create a UUID from a string such as "E621E1F8-C36C-495A-93FC-0C247A3E6E5F".
    ///
    /// Returns nil for invalid strings.
    public init?(uuidString string: String) {
        guard string.count == UUID.stringLength
            else { return nil }
        let components = string
            .split(separator: "-")
        guard components[0].count == 8,
            components[1].count == 4,
            components[2].count == 4,
            components[3].count == 4,
            components[4].count == 12
            else { return nil }
        let hexString = components
            .reduce("") { $0 + $1 }
        assert(hexString.count == UUID.length * 2)
        guard let bytes = [UInt8](hexadecimal: hexString)
            else { return nil }
        assert(bytes.count == UUID.length)
        self.init(uuid: uuid_t(bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], bytes[6], bytes[7], bytes[8], bytes[9], bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15]))
    }
    
    /// Returns a string created from the UUID, such as "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
    public var uuidString: String {
        return uuid.0.toHexadecimal()
            + uuid.1.toHexadecimal()
            + uuid.2.toHexadecimal()
            + uuid.3.toHexadecimal()
            + "-"
            + uuid.4.toHexadecimal()
            + uuid.5.toHexadecimal()
            + "-"
            + uuid.6.toHexadecimal()
            + uuid.7.toHexadecimal()
            + "-"
            + uuid.8.toHexadecimal()
            + uuid.9.toHexadecimal()
            + "-"
            + uuid.10.toHexadecimal()
            + uuid.11.toHexadecimal()
            + uuid.12.toHexadecimal()
            + uuid.13.toHexadecimal()
            + uuid.14.toHexadecimal()
            + uuid.15.toHexadecimal()
    }
}

internal extension SwiftFoundation.UUID {
    
    static var length: Int { return 16 }
    static var stringLength: Int { return 36 }
}

// MARK: - Equatable

extension SwiftFoundation.UUID: Equatable {
    
    public static func == (lhs: SwiftFoundation.UUID, rhs: SwiftFoundation.UUID) -> Bool {
        return lhs.uuid.0 == rhs.uuid.0 &&
            lhs.uuid.1 == rhs.uuid.1 &&
            lhs.uuid.2 == rhs.uuid.2 &&
            lhs.uuid.3 == rhs.uuid.3 &&
            lhs.uuid.4 == rhs.uuid.4 &&
            lhs.uuid.5 == rhs.uuid.5 &&
            lhs.uuid.6 == rhs.uuid.6 &&
            lhs.uuid.7 == rhs.uuid.7 &&
            lhs.uuid.8 == rhs.uuid.8 &&
            lhs.uuid.9 == rhs.uuid.9 &&
            lhs.uuid.10 == rhs.uuid.10 &&
            lhs.uuid.11 == rhs.uuid.11 &&
            lhs.uuid.12 == rhs.uuid.12 &&
            lhs.uuid.13 == rhs.uuid.13 &&
            lhs.uuid.14 == rhs.uuid.14 &&
            lhs.uuid.15 == rhs.uuid.15
    }
}

// MARK: - Hashable

extension UUID: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        withUnsafeBytes(of: uuid) { hasher.combine(bytes: $0) }
    }
}

// MARK: - CustomStringConvertible

extension UUID: CustomStringConvertible {
    
    public var description: String {
        return uuidString
    }
}

// MARK: - CustomReflectable

extension UUID: CustomReflectable {
    public var customMirror: Mirror {
        let c : [(label: String?, value: Any)] = []
        let m = Mirror(self, children:c, displayStyle: .struct)
        return m
    }
}

// MARK: - Codable

extension UUID: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let uuidString = try container.decode(String.self)
        
        guard let uuid = UUID(uuidString: uuidString) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath,
                                                                    debugDescription: "Attempted to decode UUID from invalid UUID string."))
        }
        
        self = uuid
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.uuidString)
    }
}

// MARK: - Supporting Types

public typealias uuid_t = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
public typealias uuid_string_t = (Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8)
