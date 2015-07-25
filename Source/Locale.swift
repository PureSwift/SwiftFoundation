//
//  Locale.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Locale. Locales are immutable.
public struct Locale {
    
    // MARK: - Class Properties and Methods
    
    public static var systemLocale: Locale {
        
        return CFLocaleGetSystem().toLocale()
    }
    
    public static var currentLocale: Locale {
        
        return CFLocaleCopyCurrent().toLocale()
    }
    
    public static var availableLocaleIdentifiers: [String] {
        
        return CFLocaleCopyAvailableLocaleIdentifiers() as! [String]
    }
    
    public static var ISOLanguageCodes: [String] {
        
        return CFLocaleCopyISOLanguageCodes() as! [String]
    }
    
    public static var ISOCountryCodes: [String] {
        
        return CFLocaleCopyISOCountryCodes() as! [String]
    }
    
    public static var ISOCurrencyCodes: [String] {
        
        return CFLocaleCopyISOCurrencyCodes() as! [String]
    }
    
    public static func localeIdentifierFromWindowsLocaleCode(code: UInt32) -> String {
        
        return CFLocaleCreateLocaleIdentifierFromWindowsLocaleCode(nil, code) as String
    }
    
    public static func windowsLocaleCodeFromLocaleIdentifier(localeIdentifier: String) -> UInt32 {
        
        return CFLocaleGetWindowsLocaleCodeFromLocaleIdentifier(localeIdentifier)
    }
    
    public static func languageCharacterDirection(forISOLanguageCode code: String) -> LocaleLanguageDirection {
        
        return CFLocaleGetLanguageCharacterDirection(code).toLocaleLanguageDirection()
    }
    
    public static func languageLineDirection(forISOLanguageCode code: String) -> LocaleLanguageDirection {
        
        return CFLocaleGetLanguageLineDirection(code).toLocaleLanguageDirection()
    }
    
    // MARK: - Properties
    
    public let localeIdentifier: String
    
    // MARK: - Initialization
    
    /// A new locale that corresponds to the arbitrary locale identifier ```localeIdentifier``` or ```nil``` if the locale identifier was invalid.
    public init?(localeIdentifier: String) {
        
        guard let locale = CFLocaleCreate(nil, localeIdentifier) else { return nil }
        
        self.localeIdentifier = localeIdentifier
        self.internalLocale = locale
    }
    
    // MARK: - Methods
    
    // TODO: Implement all locale methods
    
    // MARK: - Internal
    
    /// The underlying locale
    internal let internalLocale: CFLocaleRef
    
    internal init(internalLocale: CFLocaleRef) {
        
        self.localeIdentifier = internalLocale.localeIdentifier
        self.internalLocale = internalLocale
    }
}

/// Language direction of the locale.
public enum LocaleLanguageDirection {
    
    case Unknown
    case LeftToRight
    case RightToLeft
    case TopToBottom
    case BottomToTop
}

