//
//  CFLocale.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import CoreFoundation

public extension CFLocaleRef {
    
    static func fromLocale(locale: Locale) -> CFLocaleRef {
        
        return locale.internalLocale
    }
    
    func toLocale() -> Locale {
        
        return Locale(internalLocale: self)
    }
    
    var localeIdentifier: String {
        
        return CFLocaleGetIdentifier(self) as String
    }
}

public extension CFLocaleLanguageDirection {
    
    init(direction: LocaleLanguageDirection) {
        
        switch direction {
            
        case .Unknown:       self = Unknown
        case .LeftToRight:   self = LeftToRight
        case .RightToLeft:   self = RightToLeft
        case .TopToBottom:   self = TopToBottom
        case .BottomToTop:   self = BottomToTop
        }
    }
    
    func toLocaleLanguageDirection() -> LocaleLanguageDirection {
        
        switch self {
            
        case .Unknown:       return .Unknown
        case .LeftToRight:   return .LeftToRight
        case .RightToLeft:   return .RightToLeft
        case .TopToBottom:   return .TopToBottom
        case .BottomToTop:   return .BottomToTop
        }
    }
}