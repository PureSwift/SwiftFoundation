//
//  cURL.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/1/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import cURL

/// Class that encapsulates cURL handler.
public final class cURL: Copying {
    
    // MARK: - Typealiases
    
    public typealias Long = CLong
    
    public typealias Handler = UnsafeMutablePointer<Void>
    
    public typealias Option = CURLoption
    
    public typealias Info = CURLINFO
    
    // MARK: - Properties
    
    /// Private pointer to ```cURL.Handler```.
    private let internalHandler: cURL.Handler
    
    // MARK: - Initialization
    
    deinit {
        
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
        
        return try setOption(option, pointer)
    }
    
    /// Set boolean value for ```CURLoption```.
    public func setOption(option: Option, _ value: Bool) throws {
        
        return try setOption(option, Long(value))
    }
    
    // MARK: Get Info
    
    /// Get string value for ```CURLINFO```.
    public func getInfo(info: Info) throws -> String {
        
        var stringBytesPointer = UnsafePointer<CChar>()
        
        let code = curl_easy_getinfo(internalHandler, info: info, param: &stringBytesPointer)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
        
        return String.fromCString(stringBytesPointer)!
    }
    
    /// Get string array value for ```CURLINFO```.
    ///
    /// - Note: Equivalent for ```curl_slist``` in ```cURL``` C API.
    ///
    public func getInfo(info: Info) throws -> [String]? {
        
        // TODO: Implement stirng linked-list conversion
        
        fatalError("Not Implemented")
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
    
    // MARK: - Copying
    
    public var copy: cURL {
        
        let handleCopy = curl_easy_duphandle(internalHandler)
        
        let copy = cURL(handler: handleCopy)
        
        return copy
    }
    
    // MARK: - Supporting Types
    
    public enum Error: ErrorType {
        
        case UnsupportedProtocol
        case FailedInitialization
        case BadURLFormat
        case NotBuiltIn
        case CouldNotResolveProxy
        case CouldNotResolveHost
        case CouldNotConnect
        case FTPBadServerReply
        case RemoteAccessDenied
        
        case BadFunctionArgument
        
        
        public init?(code: CURLcode) {
                        
            switch code {
            
            case CURLE_OK:                     return nil
            case CURLE_UNSUPPORTED_PROTOCOL:   self = .UnsupportedProtocol
            case CURLE_FAILED_INIT:            self = .FailedInitialization
            case CURLE_URL_MALFORMAT:          self = .BadURLFormat
            case CURLE_NOT_BUILT_IN:           self = .NotBuiltIn
            case CURLE_COULDNT_RESOLVE_PROXY:  self = .CouldNotResolveProxy
            case CURLE_COULDNT_RESOLVE_HOST:   self = .CouldNotResolveHost
            case CURLE_COULDNT_CONNECT:        self = .CouldNotConnect
            case CURLE_FTP_WEIRD_SERVER_REPLY: self = .FTPBadServerReply
            case CURLE_REMOTE_ACCESS_DENIED:   self = .RemoteAccessDenied
            case CURLE_COULDNT_RESOLVE_HOST:   self = .FailedInitialization
            case CURLE_COULDNT_RESOLVE_HOST:   self = .FailedInitialization
            case CURLE_COULDNT_RESOLVE_HOST:   self = .FailedInitialization
            case CURLE_COULDNT_RESOLVE_HOST:   self = .FailedInitialization
            case CURLE_COULDNT_RESOLVE_HOST:   self = .FailedInitialization
            case CURLE_COULDNT_RESOLVE_HOST:   self = .FailedInitialization
            case CURLE_BAD_FUNCTION_ARGUMENT:  self = .BadFunctionArgument
                
            default:
                debugPrint("Case \(code) not handled for CURLcode -> cURL Error")
                return nil;
            }
        }
    }
}

// MARK: - Function Declarations

@asmname("curl_easy_setopt") public func curl_easy_setopt(curl: cURL.Handler, option: CURLoption, param: UnsafePointer<UInt8>) -> CURLcode

@asmname("curl_easy_getinfo") public func curl_easy_getinfo<T>(curl: cURL.Handler, info: CURLINFO, inout param: T) -> CURLcode


