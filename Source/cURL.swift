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
    
    private let internalHandler: curl_handler
    
    deinit {
        
        curl_easy_cleanup(internalHandler)
    }
    
    public init() {
        
        internalHandler = curl_easy_init()
    }
    
    public private(set) var options = [Option]()
    
    public func setOption(option: Option) throws {
        
        let (optionFlag, value) = option.rawValue
        
        let code = curl_easy_setopt(internalHandler, option: optionFlag, param: value)
        
        if let error = Error(code: code) { throw error }
        
        self.options.append(option)
    }
    
    public func perform() throws {
        
        let code = curl_easy_perform(internalHandler)
        
        if let error = Error(code: code) { throw error }
    }
    
    public func info() throws -> [Info] {
        
        var values = [Info]()
        
        for infoRawValue in 1...CURLINFO_LASTONE.rawValue {
            
            let param = UnsafeMutablePointer<Any>()
            
            let code = curl_easy_getinfo(internalHandler, info: CURLINFO(rawValue: infoRawValue), param: param)
            
            if let error = Error(code: code) { throw error }
            
            guard let info = Info(rawValue: (CURLINFO(infoRawValue), param.memory))
                else { fatalError("Could not create cURL.Info from \(infoRawValue) \(param.memory)") }
            
            values.append(info)
        }
        
        return values
    }
    
    // MARK: - Supporting Types
    
    public enum Info {
        
        case EffectiveURL(String)
        
        case ResponseCode(UInt)
        
        public init?(rawValue: (CURLINFO, Any)) {
            
            let (info, value) = rawValue
            
            switch info {
                
            case CURLINFO_EFFECTIVE_URL:
                guard let value = value as? String else { return nil }
                self = .EffectiveURL(value)
                
            case CURLINFO_RESPONSE_CODE:
                guard let value = value as? curl_long else { return nil }
                self = .ResponseCode(UInt(value))
                
            default: fatalError("cURL Info code not handled \(info) \(value)")
            }
        }
    }
    
    public enum Option {
        
        case URL(String)
        
        case Port(UInt)
        
        case Verbose(Bool)
        
        public var rawValue: (CURLoption, Any) {
            
            switch self {
                
            case .URL(let value): return (CURLOPT_URL, value)
            case .Port(let value): return (CURLOPT_PORT, curl_long(value))
            case .Verbose(let value): return (CURLOPT_VERBOSE, curl_long(value))
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
                
            default: fatalError("cURL Error code not handled \(code)")
            }
        }
    }
}


// MARK: - Function declarations

public typealias curl_handler = UnsafeMutablePointer<Void>

public typealias curl_long = CLong

@asmname("curl_easy_setopt") public func curl_easy_setopt(curl: curl_handler, option: CURLoption, param: Any...) -> CURLcode

@asmname("curl_easy_getinfo") public func curl_easy_getinfo(curl: curl_handler, info: CURLINFO, param: Any...) -> CURLcode



