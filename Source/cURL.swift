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
        
        let code = curl_easy_setopt(internalHandler, option: optionFlag, param: value as! CVarArgType)
        
        if let error = Error(code: code) { throw error }
        
        self.options.append(option)
    }
    
    public func perform() throws {
        
        let code = curl_easy_perform(internalHandler)
        
        if let error = Error(code: code) { throw error }
        
        curl_easy_getinfo(internalHandler, info: CURLINFO, param: UnsafeMutablePointer<>)
    }
    
    public var info: [Info] {
        
        for rawInfoValue in 1...CURLINFO_LASTONE.rawValue {
            
            let info = CURLINFO(rawValue: rawInfoValue)
            
            
        }
    }
    
    // MARK: - Supporting Types
    
    public enum Option {
        
        case URL(String)
        
        case Port(UInt)
        
        case Verbose(Bool)
        
        public var rawValue: (CURLoption, Any) {
            
            switch self {
                
            case .URL(let value): return (CURLOPT_URL, value)
            case .Port(let value): return (CURLOPT_PORT, Int(value))
            case .Verbose(let value): return (CURLOPT_VERBOSE, Int(value))
            }
        }
    }
    
    public enum Info {
        
        case EffectiveURL(String)
        
        public var rawValue: (CURLINFO, Any) {
            
            switch self {
                
            case .EffectiveURL(let value): return (CURLINFO_EFFECTIVE_URL, value)
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
            case CURLE_COULDNT_RESOLVE_HOST:   self = .FailedInitialization
                
            default: fatalError("cURL Error code not handled \(code)")
            }
        }
    }
}


// MARK: - Function declarations

public typealias curl_handler = UnsafeMutablePointer<Void>

@asmname("curl_easy_setopt") public func curl_easy_setopt(curl: curl_handler, option: CURLoption, param: CVarArgType...) -> CURLcode

@asmname("curl_easy_getinfo") public func curl_easy_getinfo(curl: curl_handler, info: CURLINFO, param: CVarArgType...) -> CURLcode

public func ~= (lhs: CURLcode, rhs: CURLcode) -> Bool {
    
    return lhs.rawValue ~= rhs.rawValue
}

