//
//  HTTPStatusCode.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

public extension HTTP {
    
    /// The standard status codes used with the [HTTP](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) protocol.
    public enum StatusCode: Int {
        
        // 1xx Informational
        case Continue                       = 100
        case SwitchingProtocols             = 101
        case Processing                     = 102
        
        // 2xx Success
        case OK                             = 200
        case Created                        = 201
        case Accepted                       = 202
        case NonAuthoritativeInformation    = 203
        case NoContent                      = 204
        case ResetContent                   = 205
        case PartialContent                 = 206
        case MultiStatus                    = 207
        case AlreadyReported                = 208
        case IMUsed                         = 226
        
        // 3xx Redirection
        case MultipleChoices                = 300
        case MovedPermanently               = 301
        case Found                          = 302
        case SeeOther                       = 303
        case NotModified                    = 304
        case UseProxy                       = 305
        case SwitchProxy                    = 306
        case TemporaryRedirect              = 307
        case PermanentRedirect              = 308
        
        // 4xx Client Error
        case BadRequest                     = 400
        case Unauthorized                   = 401
        case PaymentRequired                = 402
        case Forbidden                      = 403
        case NotFound                       = 404
        case MethodNotAllowed               = 405
        case NotAcceptable                  = 406
        case ProxyAuthenticationRequired    = 407
        case RequestTimeout                 = 408
        case Conflict                       = 409
        case Gone                           = 410
        case LengthRequired                 = 411
        case PreconditionFailed             = 412
        case PayloadTooLarge                = 413
        case RequestURITooLong              = 414
        case UnsupportedMediaType           = 415
        case RequestedRangeNotSatisfiable   = 416
        case ExpectationFailed              = 417
        case Teapot                         = 418
        case AuthenticationTimeout          = 419
        
        /// Enhance Your Calm ([Twitter](https://en.wikipedia.org/wiki/Twitter))
        ///
        /// Not part of the HTTP standard, but returned by version 1 of the Twitter Search and
        /// Trends API when the client is being rate limited.
        /// Other services may wish to implement the 
        /// [429 Too Many Requests](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#429) 
        /// response code instead.
        case EnhanceYourCalm                = 420
        
        /// Misdirected Request ([HTTP/2](https://en.wikipedia.org/wiki/HTTP/2))
        ///
        /// The request was directed at a server that is not able to produce a response 
        /// (for example because a connection reuse).
        case MisdirectedRequest             = 421
        
        /// Unprocessable Entity (WebDAV; RFC 4918)
        ///
        /// The request was well-formed but was unable to be followed due to semantic errors.
        case UnprocessableEntity            = 422
        
        /// Locked (WebDAV; RFC 4918)
        /// 
        /// The resource that is being accessed is locked.
        case Locked                         = 423
        
        /// Failed Dependency (WebDAV; RFC 4918)
        ///
        /// The request failed due to failure of a previous request (e.g., a PROPPATCH).
        case FailedDependency               = 424
        
        /// Upgrade Required
        ///
        /// The client should switch to a different protocol such as 
        /// [TLS/1.0](https://en.wikipedia.org/wiki/Transport_Layer_Security),
        /// given in the [Upgrade](https://en.wikipedia.org/wiki/Upgrade_header) header field.
        case UpgradeRequired                = 426
        
        /// Precondition Required ([RFC 6585](https://tools.ietf.org/html/rfc6585))
        /// 
        /// The origin server requires the request to be conditional. 
        /// Intended to prevent "the 'lost update' problem, where a client GETs a resource's state, 
        /// modifies it, and PUTs it back to the server, 
        /// when meanwhile a third party has modified the state on the server, leading to a conflict."
        case PreconditionRequired           = 428
        
        /// Too Many Requests ([RFC 6585](https://tools.ietf.org/html/rfc6585))
        ///
        /// The user has sent too many requests in a given amount of time. 
        /// Intended for use with rate limiting schemes.
        case TooManyRequests
        
        /// Request Header Fields Too Large ([RFC 6585](https://tools.ietf.org/html/rfc6585))
        ///
        /// The server is unwilling to process the request because either an individual header field,
        /// or all the header fields collectively, are too large.
        case RequestHeaderFieldsTooLarge    = 431
        
        /// Login Timeout (Microsoft)
        /// 
        /// A Microsoft extension. Indicates that your session has expired.
        case LoginTimeout                   = 440
        
        /// No Response (Nginx)
        ///
        /// Used in Nginx logs to indicate that the server has returned no information to the client
        /// and closed the connection (useful as a deterrent for malware).
        case NoResponse                     = 444
        
        /// Retry With (Microsoft)
        /// 
        /// A Microsoft extension. The request should be retried after performing the appropriate action.
        case RetryWith                      = 449
        
        /// Blocked by Windows Parental Controls (Microsoft)
        ///
        /// A Microsoft extension. 
        /// This error is given when Windows Parental Controls are turned on and are 
        /// blocking access to the given webpage.
        case BlockedByParentalControls      = 450
        
        /// [Unavailable For Legal Reasons](https://en.wikipedia.org/wiki/HTTP_451) (Internet draft)
        /// 
        /// Defined in the internet draft "A New HTTP Status Code for Legally-restricted Resources".
        /// Intended to be used when resource access is denied for legal reasons, 
        /// e.g. censorship or government-mandated blocked access.
        /// A reference to the 1953 dystopian novel Fahrenheit 451, where books are outlawed.
        case UnavailableForLegalReasons     = 451
        
        /// Redirect (Microsoft)
        /// 
        /// Used in Exchange ActiveSync if there either is a more efficient server to use or 
        /// the server cannot access the users' mailbox.
        ///
        /// The client is supposed to re-run the HTTP Autodiscovery protocol to find a better suited server.
        case Redirect                       = 
        
        // 5xx Server Error
        
        
        init() { self = .OK }
    }
}

