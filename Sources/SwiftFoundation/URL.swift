//  URL.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/**
 A URL is a type that can potentially contain the location of a resource on a remote server, the path of a local file on disk, or even an arbitrary piece of encoded data.
 
 You can construct URLs and access their parts. For URLs that represent local files, you can also manipulate properties of those files directly, such as changing the file's last modification date. Finally, you can pass URLs to other APIs to retrieve the contents of those URLs. For example, you can use the URLSession classes to access the contents of remote resources, as described in URL Session Programming Guide.
 
 URLs are the preferred way to refer to local files. Most objects that read data from or write data to a file have methods that accept a URL instead of a pathname as the file reference. For example, you can get the contents of a local file URL as `String` by calling `func init(contentsOf:encoding) throws`, or as a `Data` by calling `func init(contentsOf:options) throws`.
*/
public struct URL {
    
    internal let stringValue: String
    
    /// Initialize with string.
    ///
    /// Returns `nil` if a `URL` cannot be formed with the string (for example, if the string contains characters that are illegal in a URL, or is an empty string).
    public init?(string: String) {
        // TODO: Validate URL string
        guard string.isEmpty == false
            else { return nil }
        self.init(string: string)
    }
    
    /// Returns the absolute string for the URL.
    public var absoluteString: String {
        return stringValue
    }
}

// MARK: - Equatable

extension URL: Equatable {
    
    public static func == (lhs: URL, rhs: URL) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
}

// MARK: - Hashable

extension URL: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        stringValue.hash(into: &hasher)
    }
}

// MARK: - CustomStringConvertible

extension URL: CustomStringConvertible {
    
    public var description: String {
        return stringValue
    }
}

// MARK: - CustomDebugStringConvertible

extension URL: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return description
    }
}

// MARK: - Codable

extension URL: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let url = URL(string: string) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath,
                                                                    debugDescription: "Invalid URL string."))
        }
        self = url
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }
}
