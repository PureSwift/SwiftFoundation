//
//  POSIXError.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin.C
    import Foundation
#elseif os(Linux)
    import Glibc
#endif

public extension POSIXError {
    
    /// Creates error from C ```errno```.
    static var fromErrno: POSIXError? {
        
        guard let code = POSIXErrorCode(rawValue: errno)
            else { return nil }
        
        return self.init(code: code)
    }
    
#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    
    /// Creates `POSIXError` from error code.
    init(code: POSIXErrorCode) {
        
        let nsError = NSError(domain: NSPOSIXErrorDomain, code: Int(code.rawValue), userInfo: nil)
        
        self.init(_nsError: nsError)
    }
    
#endif

}

#if os(Linux)
    
    /// Enumeration describing POSIX error codes.
    public struct POSIXError: Error {
        
        public let code: POSIXErrorCode
        
        public init(code: POSIXErrorCode) {
            
            self.code = code
        }
    }
    
    /// Enumeration describing POSIX error codes.
    public enum POSIXErrorCode : Int32 {
        
        /// Operation not permitted.
        case EPERM           = 1
        /// No such file or directory.
        case ENOENT          = 2
        /// No such process.
        case ESRCH           = 3
        /// Interrupted system call.
        case EINTR           = 4
        /// Input/output error.
        case EIO             = 5
        /// Device not configured.
        case ENXIO           = 6
        /// Argument list too long.
        case E2BIG           = 7
        /// Exec format error.
        case ENOEXEC         = 8
        /// Bad file descriptor.
        case EBADF           = 9
        /// No child processes.
        case ECHILD          = 10
        /// Try again.
        case EAGAIN         = 11
        /// Cannot allocate memory.
        case ENOMEM          = 12
        /// Permission denied.
        case EACCES          = 13
        /// Bad address.
        case EFAULT          = 14
        /// Block device required.
        case ENOTBLK         = 15
        /// Device / Resource busy.
        case EBUSY           = 16
        /// File exists.
        case EEXIST          = 17
        /// Cross-device link.
        case EXDEV           = 18
        /// Operation not supported by device.
        case ENODEV          = 19
        /// Not a directory.
        case ENOTDIR         = 20
        /// Is a directory.
        case EISDIR          = 21
        /// Invalid argument.
        case EINVAL          = 22
        /// Too many open files in system.
        case ENFILE          = 23
        /// Too many open files.
        case EMFILE          = 24
        /// Inappropriate ioctl for device.
        case ENOTTY          = 25
        /// Text file busy.
        case ETXTBSY         = 26
        /// File too large.
        case EFBIG           = 27
        /// No space left on device.
        case ENOSPC          = 28
        /// Illegal seek.
        case ESPIPE          = 29
        /// Read-only file system.
        case EROFS           = 30
        /// Too many links.
        case EMLINK          = 31
        /// Broken pipe.
        case EPIPE           = 32
        
        /// math software.
        /// Numerical argument out of domain.
        case EDOM            = 33
        /// Result too large.
        case ERANGE          = 34
        
        /// Resource deadlock would occur.
        case EDEADLK          = 35
        
        /// File name too long.
        case ENAMETOOLONG     = 36
        
        /// No record locks available
        case ENOLCK           = 37
        
        /// Function not implemented.
        case ENOSYS           = 38
        
        /// Directory not empty.
        case ENOTEMPTY        = 39
        
        /// Too many symbolic links encountered
        case ELOOP            = 40
        
        /// Operation would block.
        public static var EWOULDBLOCK: POSIXErrorCode { return .EAGAIN }
        
        /// No message of desired type.
        case ENOMSG          = 42
        
        /// Identifier removed.
        case EIDRM           = 43
        
        /// Channel number out of range.
        case ECHRNG          = 44
        
        /// Level 2 not synchronized.
        case EL2NSYNC        = 45
        
        /// Level 3 halted
        case EL3HLT          = 46
        
        /// Level 3 reset.
        case EL3RST          = 47
        
        /// Link number out of range.
        case ELNRNG          = 48
        
        /// Protocol driver not attached.
        case EUNATCH         = 49
        
        /// No CSI structure available.
        case ENOCSI          = 50
        
        /// Level 2 halted.
        case EL2HLT          = 51
        case EBADE           = 52  /* Invalid exchange */
        case EBADR           = 53  /* Invalid request descriptor */
        case EXFULL          = 54  /* Exchange full */
        case ENOANO          = 55  /* No anode */
        case EBADRQC         = 56  /* Invalid request code */
        case EBADSLT         = 57  /* Invalid slot */
        
        public static var EDEADLOCK: POSIXErrorCode { return .EDEADLK }
        
        case EBFONT          = 59  /* Bad font file format */
        case ENOSTR          = 60  /* Device not a stream */
        case ENODATA         = 61  /* No data available */
        case ETIME           = 62  /* Timer expired */
        case ENOSR           = 63  /* Out of streams resources */
        case ENONET          = 64  /* Machine is not on the network */
        case ENOPKG          = 65  /* Package not installed */
        case EREMOTE         = 66  /* Object is remote */
        case ENOLINK         = 67  /* Link has been severed */
        case EADV            = 68  /* Advertise error */
        case ESRMNT          = 69  /* Srmount error */
        case ECOMM           = 70  /* Communication error on send */
        case EPROTO          = 71  /* Protocol error */
        case EMULTIHOP       = 72  /* Multihop attempted */
        case EDOTDOT         = 73  /* RFS specific error */
        case EBADMSG         = 74  /* Not a data message */
        case EOVERFLOW       = 75  /* Value too large for defined data type */
        case ENOTUNIQ        = 76  /* Name not unique on network */
        case EBADFD          = 77  /* File descriptor in bad state */
        case EREMCHG         = 78  /* Remote address changed */
        case ELIBACC         = 79  /* Can not access a needed shared library */
        case ELIBBAD         = 80  /* Accessing a corrupted shared library */
        case ELIBSCN         = 81  /* .lib section in a.out corrupted */
        case ELIBMAX         = 82  /* Attempting to link in too many shared libraries */
        case ELIBEXEC        = 83  /* Cannot exec a shared library directly */
        case EILSEQ          = 84  /* Illegal byte sequence */
        case ERESTART        = 85  /* Interrupted system call should be restarted */
        case ESTRPIPE        = 86  /* Streams pipe error */
        case EUSERS          = 87  /* Too many users */
        case ENOTSOCK        = 88  /* Socket operation on non-socket */
        case EDESTADDRREQ    = 89  /* Destination address required */
        case EMSGSIZE        = 90  /* Message too long */
        case EPROTOTYPE      = 91  /* Protocol wrong type for socket */
        case ENOPROTOOPT     = 92  /* Protocol not available */
        case EPROTONOSUPPORT = 93  /* Protocol not supported */
        case ESOCKTNOSUPPORT = 94  /* Socket type not supported */
        case EOPNOTSUPP      = 95  /* Operation not supported on transport endpoint */
        case EPFNOSUPPORT    = 96  /* Protocol family not supported */
        case EAFNOSUPPORT    = 97  /* Address family not supported by protocol */
        case EADDRINUSE      = 98  /* Address already in use */
        case EADDRNOTAVAIL   = 99  /* Cannot assign requested address */
        case ENETDOWN        = 100 /* Network is down */
        case ENETUNREACH     = 101 /* Network is unreachable */
        case ENETRESET       = 102 /* Network dropped connection because of reset */
        case ECONNABORTED    = 103 /* Software caused connection abort */
        case ECONNRESET      = 104 /* Connection reset by peer */
        case ENOBUFS         = 105 /* No buffer space available */
        case EISCONN         = 106 /* Transport endpoint is already connected */
        case ENOTCONN        = 107 /* Transport endpoint is not connected */
        case ESHUTDOWN       = 108 /* Cannot send after transport endpoint shutdown */
        case ETOOMANYREFS    = 109 /* Too many references: cannot splice */
        case ETIMEDOUT       = 110 /* Connection timed out */
        case ECONNREFUSED    = 111 /* Connection refused */
        case EHOSTDOWN       = 112 /* Host is down */
        case EHOSTUNREACH    = 113 /* No route to host */
        case EALREADY        = 114 /* Operation already in progress */
        case EINPROGRESS     = 115 /* Operation now in progress */
        case ESTALE          = 116 /* Stale NFS file handle */
        case EUCLEAN         = 117 /* Structure needs cleaning */
        case ENOTNAM         = 118 /* Not a XENIX named type file */
        case ENAVAIL         = 119 /* No XENIX semaphores available */
        case EISNAM          = 120 /* Is a named type file */
        case EREMOTEIO       = 121 /* Remote I/O error */
        case EDQUOT          = 122 /* Quota exceeded */
        
        case ENOMEDIUM       = 123 /* No medium found */
        case EMEDIUMTYPE     = 124 /* Wrong medium type */
        case ECANCELED       = 125 /* Operation Canceled */
        case ENOKEY          = 126 /* Required key not available */
        case EKEYEXPIRED     = 127 /* Key has expired */
        case EKEYREVOKED     = 128 /* Key has been revoked */
        case EKEYREJECTED    = 129 /* Key was rejected by service */
        
        /* for robust mutexes */
        case EOWNERDEAD      = 130 /* Owner died */
        case ENOTRECOVERABLE = 131 /* State not recoverable */
    }
    
#endif


