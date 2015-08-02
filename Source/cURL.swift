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
    
    private let internalHandler: UnsafeMutablePointer<Void>
    
    deinit {
        
        curl_easy_cleanup(internalHandler)
    }
    
    public init() {
        
        internalHandler = curl_easy_init()
    }
    
    public private(set) var options = [Option]()
    
    public func setOption(option: Option) throws {
        
        switch option {
            
        case .URL(let value):
            
            let code = curl_easy_setopt(internalHandler, option: CURLOPT_URL, param: value)
            
            if let error = Error(code: code) { throw error }
            
        case .Port(let value):
            
            let code = curl_easy_setopt(internalHandler, option: CURLOPT_PORT, param: value)
            
            if let error = Error(code: code) { throw error }
        }
        
        self.options.append(option)
    }
    
    public func perform() throws {
        
        let code = curl_easy_perform(internalHandler)
        
        if let error = Error(code: code) { throw error }
    }
    
    public enum Option {
        
        case URL(String)
        
        case Port(UInt)
        
        public var rawValue: (CURLoption, Any) {
            
            switch self {
                
            case .URL(let value): return (CURLOPT_URL, value)
            case .Port(let value): return (CURLOPT_PORT, Int(value))
            }
        }
    }
    
    public enum Error: ErrorType {
        
        case UnsupportedProtocol
        
        case FailedInitialization
        
        public init?(code: CURLcode) {
            
            switch code.rawValue {
                
            case CURLE_UNSUPPORTED_PROTOCOL.rawValue: self = .UnsupportedProtocol
                
            case CURLE_UNSUPPORTED_PROTOCOL.rawValue: self = .FailedInitialization
                
            default: return nil
            }
        }
    }
}


// MARK: - Function declarations

@asmname("curl_easy_setopt") func curl_easy_setopt(curl: UnsafeMutablePointer<Void>, option: CURLoption, param: CVarArgType...) -> CURLcode


