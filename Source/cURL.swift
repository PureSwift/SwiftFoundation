//
//  cURL.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/1/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import cURL

/// Class that encapsulates cURL handler.
public final class cURL {
    
    // MARK: - Typealiases
    
    public typealias Long = CLong
    
    public typealias Handler = UnsafeMutablePointer<Void>
    
    public typealias Option = CURLoption
    
    public typealias Info = CURLINFO
    
    public typealias StringList = curl_slist
    
    // MARK: - Properties
    
    /// Private pointer to ```cURL.Handler```.
    private let internalHandler: Handler
    
    /// Private pointer to
    private var internalOptionStringLists: [Option.RawValue: UnsafeMutablePointer<StringList>] = [:]
    
    // MARK: - Initialization
    
    deinit {
        
        // free string lists
        for (_, pointer) in self.internalOptionStringLists {
            
            if pointer != nil {
                
                pointer.memory.free()
                
                pointer.destroy()
            }
        }
        
        curl_easy_cleanup(internalHandler)
    }
    
    public init() {
        
        internalHandler = curl_easy_init()
    }
    
    private init(handler: Handler) {
        
        self.internalHandler = handler
    }
    
    // MARK: - Methods
    
    /// Resets the state of the receiver.
    ///
    /// Re-initializes the internal ```CURL``` handle to the default values.
    /// This puts back the handle to the same state as it was in when it was just created.
    ///
    /// - Note: It does keep: live connections, the Session ID cache, the DNS cache and the cookies.
    ///
    public func reset() {
        
        curl_easy_reset(internalHandler)
    }
    
    /// Executes the request. 
    public func perform() throws {
        
        let code = curl_easy_perform(internalHandler)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
    }
    
    // MARK: - Set Option
    
    /// Set object pointer value for ```CURLoption```.
    public func setOption(option: Option, _ value: UnsafePointer<UInt8>) throws {
        
        let code = curl_easy_setopt(internalHandler, option: option, param: value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
    }
    
    /// Set ```cURL.Long``` value for ```CURLoption```.
    public func setOption(option: Option, _ value: Long) throws {
        
        let pointer = unsafeBitCast(value, UnsafePointer<UInt8>.self)
        
        try setOption(option, pointer)
    }
    
    /// Set boolean value for ```CURLoption```.
    public func setOption(option: Option, _ value: Bool) throws {
        
        try setOption(option, Long(value))
    }
    
    /// Set string list value for ```CURLoption```.
    public func setOption(option: Option, _ value: [String]) throws {
        
        // will dealloc in deinit
        var pointer = UnsafeMutablePointer<StringList>()
        
        for string in value {
            
            pointer = curl_slist_append(pointer, string)
        }
        
        try setOption(option, unsafeBitCast(pointer, UnsafeMutablePointer<UInt8>.self))
        
        internalOptionStringLists[option.rawValue] = pointer
    }
    
    // MARK: Get Info
    
    /// Get string value for ```CURLINFO```.
    public func getInfo(info: Info) throws -> String {
        
        var stringBytesPointer = UnsafePointer<CChar>()
        
        let code = curl_easy_getinfo(internalHandler, info: info, param: &stringBytesPointer)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
        
        return String.fromCString(stringBytesPointer)!
    }
    
    /// Get ```Long``` value for ```CURLINFO```.
    public func getInfo(info: Info) throws -> Long {
        
        var value: Long = 0
        
        let code = curl_easy_getinfo(internalHandler, info: info, param: &value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
        
        return value
    }
    
    /// Get ```Double``` value for ```CURLINFO```.
    public func getInfo(info: Info) throws -> Double {
        
        var value: Double = 0
        
        let code = curl_easy_getinfo(internalHandler, info: info, param: &value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
        
        return value
    }
}

// MARK: - Function Declarations

@asmname("curl_easy_setopt") public func curl_easy_setopt(curl: cURL.Handler, option: cURL.Option, param: UnsafePointer<UInt8>) -> CURLcode

@asmname("curl_easy_getinfo") public func curl_easy_getinfo<T>(curl: cURL.Handler, info: cURL.Info, inout param: T) -> CURLcode


