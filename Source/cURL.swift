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
    
    // MARK: - Properties
    
    public private(set) var options = [Option]()
    
    private let internalHandler: cURL.Handler
    
    // MARK: - Initialization
    
    deinit {
        
        curl_easy_cleanup(internalHandler)
    }
    
    public init() {
        
        internalHandler = curl_easy_init()
    }
    
    private init(handler: Handler, options: [Option]) {
        
        self.internalHandler = handler
        self.options = options
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
        
        options = []
    }
    
    public func setOption(option: Option) throws {
        
        var code: CURLcode!
        
        switch option {
            
        // String Options
            
        case .URL(let value):
            code = curl_easy_setopt(internalHandler, option: CURLOPT_URL, param: value)
            
        case .CustomRequest(let value):
            code = curl_easy_setopt(internalHandler, option: CURLOPT_CUSTOMREQUEST, param: value)
            
        // Long Options
            
        case .Port(let value):
            let pointer = unsafeBitCast(Long(value), UnsafeMutablePointer<UInt8>.self)
            code = curl_easy_setopt(internalHandler, option: CURLOPT_PORT, param: pointer)
            
        case .Verbose(let value):
            let pointer = unsafeBitCast(Long(value), UnsafeMutablePointer<UInt8>.self)
            code = curl_easy_setopt(internalHandler, option: CURLOPT_VERBOSE, param: pointer)
            
        case .Timeout(let value):
            let pointer = unsafeBitCast(Long(value), UnsafeMutablePointer<UInt8>.self)
            code = curl_easy_setopt(internalHandler, option: CURLOPT_TIMEOUT, param: pointer)
            
        case .POST(let value):
            let pointer = unsafeBitCast(Long(value), UnsafeMutablePointer<UInt8>.self)
            code = curl_easy_setopt(internalHandler, option: CURLOPT_POST, param: pointer)
            
        case .PUT(let value):
            let pointer = unsafeBitCast(Long(value), UnsafeMutablePointer<UInt8>.self)
            code = curl_easy_setopt(internalHandler, option: CURLOPT_PUT, param: pointer)
            
        case .FailOnError(let value):
            let pointer = unsafeBitCast(Long(value), UnsafeMutablePointer<UInt8>.self)
            code = curl_easy_setopt(internalHandler, option: CURLOPT_FAILONERROR, param: pointer)
            
        case .MaxConnections(let value):
            let pointer = unsafeBitCast(Long(value), UnsafeMutablePointer<UInt8>.self)
            code = curl_easy_setopt(internalHandler, option: CURLOPT_MAXCONNECTS, param: pointer)
            
        default: fatalError("Setting option \(option) is not implemented")
        }
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
        
        self.options.append(option)
    }
    
    public func perform() throws {
        
        let code = curl_easy_perform(internalHandler)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
    }
    
    // MARK: Get Info
    
    public func stringForInfo(info: CURLINFO) throws -> String? {
        
        var stringBytesPointer = UnsafePointer<CChar>()
        
        let code = curl_easy_getinfo(internalHandler, info: info, param: &stringBytesPointer)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
        
        return String.fromCString(stringBytesPointer)
    }
    
    public func stringListForInfo(info: CURLINFO) throws -> [String]? {
        
        // TODO: Implement stirng linked-list conversion
        
        fatalError("Not Implemented")
    }
    
    public func longForInfo(info: CURLINFO) throws -> Long {
        
        var value: Long = 0
        
        let code = curl_easy_getinfo(internalHandler, info: info, param: &value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
        
        return value
    }
    
    public func doubleForInfo(info: CURLINFO) throws -> Double {
        
        var value: Double = 0
        
        let code = curl_easy_getinfo(internalHandler, info: info, param: &value)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
        
        return value
    }
    
    // MARK: - Copying
    
    public var copy: cURL {
        
        let handleCopy = curl_easy_duphandle(internalHandler)
        
        let copy = cURL(handler: handleCopy, options: self.options)
        
        return copy
    }
    
    // MARK: - Supporting Types
    
    public enum Option {
        
        case URL(String)
        
        case Port(UInt)
        
        case Verbose(Bool)
        
        case Timeout(UInt)
        
        case FTPPort(String)
        
        case UserAgent(String)
        
        case HTTPHeaders([String])
        
        /// Custom request, for customizing the get command like
        /// HTTP: DELETE, TRACE and others
        /// FTP: to use a different list command
        case CustomRequest(String)
        
        /// No output on http error codes >= 400
        case FailOnError(Bool)
        
        /// HTTP POST method
        case POST(Bool)
        
        /// HTTP PUT Method
        case PUT(Bool)
        
        /// Max amount of cached keep alive connections.
        case MaxConnections(UInt)
        
        case HTTPVersion(cURL.HTTPVersion)
        
        /// Set if we should verify the Common name from the peer certificate in ssl
        /// handshake, set 1 to check existence, 2 to ensure that it matches the
        /// provided hostname.
        case SSLVerifyHost(Long)
        
        /// zero terminated string for pass on to the FTP server when asked for "account" info.
        case FTPAccount(String)
        
        case IgnoreContentLength(Bool)
        
        case Username(String)
        
        case Password(String)
        
        
    }
    
    /// cURL HTTP version
    public enum HTTPVersion: RawRepresentable {
        
        case None
        case v1_0
        case v1_1
        case v2_0
        
        public init?(rawValue: Int) {
            
            switch rawValue {
                
            case CURL_HTTP_VERSION_NONE:    self = .None
            case CURL_HTTP_VERSION_1_0:     self = .v1_0
            case CURL_HTTP_VERSION_1_1:     self = .v1_1
            case CURL_HTTP_VERSION_2_0:     self = .v2_0
                
            default: return nil
            }
        }
        
        public var rawValue: Int {
            
            switch self {
                
            case .None: return CURL_HTTP_VERSION_NONE
            case .v1_0: return CURL_HTTP_VERSION_1_0
            case .v1_1: return CURL_HTTP_VERSION_1_1
            case .v2_0: return CURL_HTTP_VERSION_2_0
            }
        }
        
        public init?(version: SwiftFoundation.HTTPVersion) {
            
            switch (version.major, version.minor) {
            
            case (1,0): self = .v1_0
            case (1,1): self = .v1_1
            case (2,0): self = .v2_0
            
            default: return nil
            }
        }
        
        public func toHTTPVersion() -> SwiftFoundation.HTTPVersion? {
            
            switch self {
                
            case .None: return nil
            case .v1_0: return SwiftFoundation.HTTPVersion(1, 0)
            case .v1_1: return SwiftFoundation.HTTPVersion(1, 1)
            case .v2_0: return SwiftFoundation.HTTPVersion(2, 0)
            }
        }
    }
    
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
    
    // MARK: - Function Declarations
    
    @asmname("curl_easy_setopt") public func curl_easy_setopt(curl: Handler, option: CURLoption, param: UnsafePointer<UInt8>) -> CURLcode
    
    @asmname("curl_easy_getinfo") public func curl_easy_getinfo<T>(curl: Handler, info: CURLINFO, inout param: T) -> CURLcode
}



