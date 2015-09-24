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
        
        /// Initializes to 200.
        public init() { self = .OK }
        
        // MARK: - 1xx Informational
        
        /// Continue
        ///
        /// This means that the server has received the request headers, 
        /// and that the client should proceed to send the request body 
        /// (in the case of a request for which a body needs to be sent; for example, a POST request). 
        /// If the request body is large, sending it to a server when a request has already been rejected 
        /// based upon inappropriate headers is inefficient. 
        /// To have a server check if the request could be accepted based on the request's headers alone,
        /// a client must send Expect: 100-continue as a header in its initial request and check if a 100
        /// Continue status code is received in response before continuing 
        /// (or receive 417 Expectation Failed and not continue).
        case Continue                       = 100
        
        /// Switching Protocols
        ///
        /// This means the requester has asked the server to switch protocols and the server 
        /// is acknowledging that it will do so.
        case SwitchingProtocols             = 101
        
        /// Processing (WebDAV; RFC 2518)
        ///
        /// As a WebDAV request may contain many sub-requests involving file operations, 
        /// it may take a long time to complete the request. 
        /// This code indicates that the server has received and is processing the request, 
        /// but no response is available yet.
        /// This prevents the client from timing out and assuming the request was lost.
        case Processing                     = 102
        
        // MARK: - 2xx Success
        
        /// OK
        ///
        /// Standard response for successful HTTP requests. 
        /// The actual response will depend on the request method used. 
        /// In a GET request, the response will contain an entity corresponding to the requested resource. 
        /// In a POST request, the response will contain an entity describing or containing 
        /// the result of the action.
        case OK                             = 200
        
        /// Created
        ///
        /// The request has been fulfilled and resulted in a new resource being created.
        case Created                        = 201
        
        /// Accepted
        ///
        /// The request has been accepted for processing, but the processing has not been completed.
        /// The request might or might not eventually be acted upon, 
        /// as it might be disallowed when processing actually takes place.
        case Accepted                       = 202
        
        /// Non-Authoritative Information (since HTTP/1.1)
        ///
        /// The server successfully processed the request, 
        /// but is returning information that may be from another source.
        case NonAuthoritativeInformation    = 203
        
        /// No Content
        ///
        /// The server successfully processed the request, but is not returning any content.
        case NoContent                      = 204
        
        /// Reset Content
        ///
        /// The server successfully processed the request, but is not returning any content.
        /// Unlike a 204 response, this response requires that the requester reset the document view.
        case ResetContent                   = 205
        
        /// Partial Content ([RFC 7233](https://tools.ietf.org/html/rfc7233))
        ///
        /// The server is delivering only part of the resource 
        /// ([byte serving](https://en.wikipedia.org/wiki/Byte_serving)) due to a range header sent
        /// by the client. The range header is used by HTTP clients to enable resuming of interrupted 
        /// downloads, or split a download into multiple simultaneous streams.
        case PartialContent                 = 206
        
        /// Multi-Status (WebDAV; RFC 4918)
        ///
        /// The message body that follows is an XML message and can contain a number of separate response 
        /// codes, depending on how many sub-requests were made.
        case MultiStatus                    = 207
        
        /// Already Reported (WebDAV; RFC 5842)
        ///
        /// The members of a DAV binding have already been enumerated in a previous reply to this request, 
        /// and are not being included again.
        case AlreadyReported                = 208
        
        /// IM Used (RFC 3229)
        ///
        /// The server has fulfilled a request for the resource, and the response is a representation of the
        /// result of one or more instance-manipulations applied to the current instance.
        case IMUsed                         = 226
        
        // MARK: - 3xx Redirection
        
        /// Multiple Choices
        /// 
        /// Indicates multiple options for the resource that the client may follow. 
        /// It, for instance, could be used to present different format options for video, 
        /// list files with different extensions, or word sense disambiguation.
        case MultipleChoices                = 300
        
        /// [Moved Permanently](https://en.wikipedia.org/wiki/HTTP_301)
        /// 
        /// This and all future requests should be directed to the given URI.
        case MovedPermanently               = 301
        
        /// [Found](https://en.wikipedia.org/wiki/HTTP_302)
        /// 
        /// This is an example of industry practice contradicting the standard. 
        /// The HTTP/1.0 specification (RFC 1945) required the client to perform a temporary redirect 
        /// (the original describing phrase was "Moved Temporarily"), but popular browsers implemented 302
        /// with the functionality of a 303.
        ///
        /// Therefore, HTTP/1.1 added status codes 303 and 307 to distinguish between the two behaviours.
        /// However, some Web applications and frameworks use the 302 status code as if it were the 303.
        case Found                          = 302
        
        /// See Other (since HTTP/1.1)
        ///
        /// The response to the request can be found under another URI using a GET method. 
        /// When received in response to a POST (or PUT/DELETE), it should be assumed that the server 
        /// has received the data and the redirect should be issued with a separate GET message.
        case SeeOther                       = 303
        
        /// Not Modified ([RFC 7232](https://tools.ietf.org/html/rfc7232))
        /// 
        /// Indicates that the resource has not been modified since the version specified by the request 
        /// headers If-Modified-Since or If-None-Match. 
        /// This means that there is no need to retransmit the resource, 
        /// since the client still has a previously-downloaded copy.
        case NotModified                    = 304
        
        /// Use Proxy (since HTTP/1.1)
        /// 
        /// The requested resource is only available through a proxy, whose address is provided in the 
        /// response. Many HTTP clients (such as Mozilla and Internet Explorer) do not correctly handle
        /// responses with this status code, primarily for security reasons
        case UseProxy                       = 305
        
        /// Switch Proxy
        /// 
        /// No longer used. Originally meant "Subsequent requests should use the specified proxy."
        case SwitchProxy                    = 306
        
        /// Temporary Redirect (since HTTP/1.1)
        /// 
        /// In this case, the request should be repeated with another URI; 
        /// however, future requests should still use the original URI. 
        ///
        /// In contrast to how 302 was historically implemented, the request method is not allowed to be
        /// changed when reissuing the original request. 
        /// For instance, a POST request should be repeated using another POST request.
        case TemporaryRedirect              = 307
        
        /// Permanent Redirect (RFC 7538)
        /// 
        /// The request, and all future requests should be repeated using another URI. 307 and 308 
        /// (as proposed) parallel the behaviours of 302 and 301, but do not allow the HTTP method to change.
        /// So, for example, submitting a form to a permanently redirected resource may continue smoothly.
        case PermanentRedirect              = 308
        
        // MARK: - 4xx Client Error
        
        /// Bad Request
        /// 
        /// The server cannot or will not process the request due to something that is perceived to be a client
        /// error (e.g., malformed request syntax, invalid request message framing, 
        /// or deceptive request routing)
        case BadRequest                     = 400
        
        /// Unauthorized ([RFC 7235](https://tools.ietf.org/html/rfc7235))
        ///
        /// Similar to **403 Forbidden**, but specifically for use when authentication is required and has
        /// failed or has not yet been provided.
        /// The response must include a WWW-Authenticate header field containing
        /// a challenge applicable to the requested resource.
        case Unauthorized                   = 401
        
        /// Payment Required
        /// 
        /// Reserved for future use. 
        /// The original intention was that this code might be used as part of some form of digital cash or
        /// micropayment scheme, but that has not happened, and this code is not usually used. 
        ///
        /// [YouTube](youtube.com) uses this status if a particular IP address has made excessive requests,
        /// and requires the person to enter a CAPTCHA.
        case PaymentRequired                = 402
        
        /// [Forbidden](https://en.wikipedia.org/wiki/HTTP_403)
        /// 
        /// The request was a valid request, but the server is refusing to respond to it. 
        /// Unlike a 401 Unauthorized response, authenticating will make no difference.
        case Forbidden                      = 403
        
        /// [Not Found](https://en.wikipedia.org/wiki/HTTP_404)
        /// 
        /// The requested resource could not be found but may be available again in the future. Subsequent requests by the client are permissible.
        case NotFound                       = 404
        
        /// Method Not Allowed
        /// 
        /// A request was made of a resource using a request method not supported by that resource; 
        /// for example, using GET on a form which requires data to be presented via POST,
        /// or using PUT on a read-only resource.
        case MethodNotAllowed               = 405
        
        /// Not Acceptable
        /// 
        /// The requested resource is only capable of generating content not acceptable according to the 
        /// **Accept** headers sent in the request.
        case NotAcceptable                  = 406
        
        /// Proxy Authentication Required ([RFC 7235](https://tools.ietf.org/html/rfc7235))
        /// 
        /// The client must first authenticate itself with the proxy.
        case ProxyAuthenticationRequired    = 407
        
        /// Request Timeout
        /// 
        /// The server timed out waiting for the request. According to HTTP specifications: 
        ///
        /// "The client did not produce a request within the time that the server was prepared to wait. 
        /// The client MAY repeat the request without modifications at any later time."
        case RequestTimeout                 = 408
        
        /// Conflict
        ///
        /// Indicates that the request could not be processed because of conflict in the request, 
        /// such as an [edit conflict](https://en.wikipedia.org/wiki/Edit_conflict) 
        /// in the case of multiple updates.
        case Conflict                       = 409
        
        /// Gone
        ///
        /// Indicates that the resource requested is no longer available and will not be available again. 
        /// This should be used when a resource has been intentionally removed and the resource should be
        /// purged. Upon receiving a 410 status code, the client should not request the resource again in the
        /// future. Clients such as search engines should remove the resource from their indices.
        /// Most use cases do not require clients and search engines to purge the resource, 
        /// and a **404 Not Found** may be used instead.
        case Gone                           = 410
        
        /// Length Required
        /// 
        /// The request did not specify the length of its content, which is required by the requested resource.
        case LengthRequired                 = 411
        
        /// Precondition Failed ([RFC 7232](https://tools.ietf.org/html/rfc7232))
        /// 
        /// The server does not meet one of the preconditions that the requester put on the request.
        case PreconditionFailed             = 412
        
        /// Payload Too Large ([RFC 7231](https://tools.ietf.org/html/rfc7231))
        ///
        /// The request is larger than the server is willing or able to process.
        ///
        /// Called "Request Entity Too Large " previously.
        case PayloadTooLarge                = 413
        
        /// Request-URI Too Long
        ///
        /// The URI provided was too long for the server to process. 
        /// Often the result of too much data being encoded as a query-string of a GET request, 
        /// in which case it should be converted to a POST request.
        case RequestURITooLong              = 414
        
        /// Unsupported Media Type
        /// 
        /// The request entity has a [media type](https://en.wikipedia.org/wiki/Internet_media_type) 
        /// which the server or resource does not support.
        /// 
        /// For example, the client uploads an image as image/svg+xml, 
        /// but the server requires that images use a different format.
        case UnsupportedMediaType           = 415
        
        /// Requested Range Not Satisfiable ([RFC 7233](https://tools.ietf.org/html/rfc7233))
        /// 
        /// The client has asked for a portion of the file 
        /// ([byte serving](https://en.wikipedia.org/wiki/Byte_serving)),
        /// but the server cannot supply that portion. 
        /// 
        /// For example, if the client asked for a part of the file that lies beyond the end of the file.
        case RequestedRangeNotSatisfiable   = 416
        
        /// Expectation Failed
        /// 
        /// The server cannot meet the requirements of the **Expect** request-header field.
        case ExpectationFailed              = 417
        
        /// I'm a teapot (RFC 2324)
        ///
        /// This code was defined in 1998 as one of the traditional IETF April Fools' jokes, 
        /// in [RFC 2324](https://tools.ietf.org/html/rfc2324), 
        /// [Hyper Text Coffee Pot Control Protocol](https://en.wikipedia.org/wiki/Hyper_Text_Coffee_Pot_Control_Protocol), 
        /// and is not expected to be implemented by actual HTTP servers. 
        /// 
        /// The RFC specifies this code should be returned by tea pots requested to brew coffee.
        case Teapot                         = 418
        
        /// Authentication Timeout (not in [RFC 2616](https://tools.ietf.org/html/rfc2616))
        /// 
        /// Not a part of the HTTP standard, **419 Authentication Timeout** denotes that previously valid
        /// authentication has expired. It is used as an alternative to **401 Unauthorized**
        /// in order to differentiate from otherwise authenticated clients being denied access to
        /// specific server resources.
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
        
        /// Request Header Too Large (Nginx)
        ///
        /// Nginx internal code similar to 431 but it was introduced earlier in version 0.9.4 
        /// (on January 21, 2011).
        case RequestHeaderTooLarge          = 494
        
        /// Cert Error (Nginx)
        /// 
        /// Nginx internal code used when SSL client certificate error occurred to distinguish it 
        /// from 4XX in a log and an error page redirection.
        case CertError                      = 495
        
        // MARK: - 5xx Server Error
        
        /// Internal Server Error
        ///
        /// A generic error message, given when an unexpected condition was encountered and 
        /// no more specific message is suitable.
        case InternalServerError            = 500
        
        /// Not Implemented
        ///
        /// The server either does not recognize the request method, 
        /// or it lacks the ability to fulfill the request.
        /// Usually this implies future availability (e.g., a new feature of a web-service API).
        case NotImplemented                 = 501
        
        /// Bad Gateway
        ///
        /// The server was acting as a gateway or proxy and received an invalid response 
        /// from the upstream server.
        case BadGateway                     = 502
        
        /// Service Unavailable
        /// 
        /// The server is currently unavailable (because it is overloaded or down for maintenance).
        /// Generally, this is a temporary state.
        case ServiceUnavailable             = 503
        
        /// Gateway Timeout
        ///
        /// The server was acting as a gateway or proxy and did not receive a timely response 
        /// from the upstream server.
        case GatewayTimeout                 = 504
        
        /// Version Not Supported
        /// 
        /// The server does not support the HTTP protocol version used in the request.
        case VersionNotSupported            = 505
        
        /// Variant Also Negotiates (RFC 2295)
        ///
        /// Transparent content negotiation for the request results in a circular reference.
        case VariantAlsoNegotiates          = 506
        
        /// Insufficient Storage (WebDAV; RFC 4918)
        ///
        /// The server is unable to store the representation needed to complete the request. 
        case InsufficientStorage            = 507
        
        /// Loop Detected (WebDAV; RFC 5842)
        ///
        /// The server detected an infinite loop while processing the request (sent in lieu of
        /// [208 Already Reported](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#208)).
        case LoopDetected                   = 508
        
        /// Bandwidth Limit Exceeded (Apache bw/limited extension)
        ///
        /// This status code is not specified in any RFCs. Its use is unknown.
        case BandwidthLimitExceeded         = 509
        
        /// Not Extended (RFC 2774)
        ///
        /// Further extensions to the request are required for the server to fulfil it.
        case NotExtended                    = 510
        
        /// Network Authentication Required ([RFC 6585](https://tools.ietf.org/html/rfc6585))
        ///
        /// The client needs to authenticate to gain network access. 
        /// Intended for use by intercepting proxies used to control access to the network 
        /// (e.g., "captive portals" used to require agreement to Terms of Service before granting 
        /// full Internet access via a Wi-Fi hotspot).
        case NetworkAuthenticationRequired  = 511
        
        /// Unknown Error
        ///
        /// This status code is not specified in any RFC and is returned by certain services, 
        /// for instance Microsoft Azure and CloudFlare servers: 
        ///
        /// "The 520 error is essentially a “catch-all” response for when the origin server returns something 
        /// unexpected or something that is not tolerated/interpreted (protocol violation or empty response)."
        case UnknownError                   = 520
        
        /// Origin Connection Time-out
        ///
        /// This status code is not specified in any RFCs, 
        /// but is used by CloudFlare's reverse proxies to signal that a server connection timed out.
        case OriginConnectionTimeOut        = 522
        
    }
}

