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
    }
    
    public func setOption(option: Option) throws {
        
        var code: CURLcode!
        
        switch option {
            
        case .URL(let value):
            code = curl_easy_setopt(internalHandler, option: CURLOPT_URL, param: value)
            
        case .Port(let value):
            let pointer = unsafeBitCast(Long(value), UnsafeMutablePointer<UInt8>.self)
            code = curl_easy_setopt(internalHandler, option: CURLOPT_PORT, param: pointer)
            
        case .Verbose(let value):
            let pointer = unsafeBitCast(Long(value), UnsafeMutablePointer<UInt8>.self)
            code = curl_easy_setopt(internalHandler, option: CURLOPT_VERBOSE, param: pointer)
        }
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
        
        self.options.append(option)
    }
    
    public func perform() throws {
        
        let code = curl_easy_perform(internalHandler)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
    }
    
    public func info() throws -> [Info] {
        
        var values = [Info]()
        
        /// from 1 to 43
        for infoRawValue in 1...CURLINFO_LASTONE.rawValue {
            
            let cURLInfo = CURLINFO(infoRawValue)
            
            let info: Info? = try {
                
                switch cURLInfo.rawValue {
                    
                case CURLINFO_EFFECTIVE_URL.rawValue:
                    
                    guard let value = try stringForInfo(cURLInfo) else { return nil }
                    
                    return Info.EffectiveURL(value)
                    
                case CURLINFO_RESPONSE_CODE.rawValue:
                    
                    let value = try longForInfo(cURLInfo)
                    
                    guard value != 0 else { return nil }
            
                    return Info.ResponseCode(UInt(value))
                    
                default: return nil //fatalError("cURL Info code not handled \(cURLInfo.rawValue)")
                }
            }()
            
            // add to output array if value could be extracted
            if let info = info { values.append(info) }
        }
        
        return values
    }
    
    // MARK: - Private Methods
    
    private func stringForInfo(info: CURLINFO) throws -> String? {
        
        var stringBytesPointer = UnsafePointer<CChar>()
        
        let code = curl_easy_getinfo(internalHandler, info: info, param: &stringBytesPointer)
        
        guard code.rawValue == CURLE_OK.rawValue else { throw Error(code: code)! }
        
        return String.fromCString(stringBytesPointer)
    }
    
    private func longForInfo(info: CURLINFO) throws -> Long {
        
        var value: Long = 0
        
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
    
    public enum Info {
        
        case EffectiveURL(String)
        
        case ResponseCode(UInt)
    }
    
    public enum Option {
        
        case URL(String)
        
        case Port(UInt)
        
        case Verbose(Bool)
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



