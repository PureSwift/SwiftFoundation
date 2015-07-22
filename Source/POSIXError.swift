//
//  POSIXError.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public extension POSIXError {
    
    /// Creates error from C ```errno```.
    static var fromErrorNumber: POSIXError? { return self.init(rawValue: errno) }
    
    var error: StandardError {
        
        switch self {
            
        case EPERM: return .OperationNotPermitted
        case ENOENT: return .NoFile
        case ESRCH: return .NoProcess
        case EINTR: return .InterruptedSystemCall
        case EIO: return .InputOutput
        case ENXIO: return .DeviceNotConfigured
        case E2BIG: return .BigArgumentList
        case ENOEXEC: return .ExecutableFormatError
        case EBADF: return .BadFileDescriptor
        case ECHILD: return .NoChildProcesses
        case EDEADLK: return .ResourceDeadlockAvoided
        case ENOMEM: return .NoMemory
        case EACCES: return .PermissionDenied
        case EFAULT: return .BadAddress
        case ENOTBLK: return .BlockDeviceRequired
        case EBUSY: return .Busy
        case EEXIST: return .FileExists
        case EXDEV: return .CrossDeviceLink
        case ENODEV: return .OperationNotSupported
        case ENOTDIR: return .NotDirectory
        case EISDIR: return .IsDirectory
        case EINVAL: return .InvalidArgument
        case ENFILE: return .TooManyOpenFilesInSystem
        case EMFILE: return .TooManyOpenFiles
        case ENOTTY: return .InappropriateIOControl
        case ETXTBSY: return .TextFileBusy
        case EFBIG: return .FileTooLarge
        case ENOSPC: return .NoSpace
        case ESPIPE: return .IllegalSeek
            
        // TODO: Implement all errors
            /*
        case EROFS: return
        case EMLINK
        case EPIPE
        case EDOM
        case ERANGE
        case EAGAIN
        case EINPROGRESS
        case EALREADY
        case ENOTSOCK
        case EDESTADDRREQ
        case EMSGSIZE
        case EPROTOTYPE
        case ENOPROTOOPT
        case EPROTONOSUPPORT
        case ESOCKTNOSUPPORT
        case ENOTSUP
        case EPFNOSUPPORT
        case EAFNOSUPPORT
        case EADDRINUSE
        case EADDRNOTAVAIL
        case ENETDOWN
        case ENETUNREACH
        case ENETRESET
        case ECONNABORTED
        case ECONNRESET
        case ENOBUFS
        case EISCONN
        case ENOTCONN
        case ESHUTDOWN
        case ETOOMANYREFS
        case ETIMEDOUT
        case ECONNREFUSED
        case ELOOP
        case ENAMETOOLONG
        case EHOSTDOWN
        case EHOSTUNREACH
        case ENOTEMPTY
        case EPROCLIM
        case EUSERS
        case EDQUOT
        case ESTALE
        case EREMOTE
        case EBADRPC
        case ERPCMISMATCH
        case EPROGUNAVAIL
        case EPROGMISMATCH
        case EPROCUNAVAIL
        case ENOLCK
        case ENOSYS
        case EFTYPE
        case EAUTH
        case ENEEDAUTH
        case EPWROFF
        case EDEVERR
        case EOVERFLOW
        case EBADEXEC
        case EBADARCH
        case ESHLIBVERS
        case EBADMACHO
        case ECANCELED
        case EIDRM
        case ENOMSG
        case EILSEQ
        case ENOATTR
        case EBADMSG
        case EMULTIHOP
        case ENODATA
        case ENOLINK
        case ENOSR
        case ENOSTR
        case EPROTO
        case ETIME
        case ENOPOLICY
        case ENOTRECOVERABLE
        case EOWNERDEAD
        case EQFULL

            */
            
        default: return .OperationNotPermitted // TEMP
        }
    }
}

/// Standard POSIX Error
public enum StandardError: ErrorType {
    
    /// Operation not permitted
    case OperationNotPermitted
    
    /// No such file or directory
    case NoFile
    
    /// No such process
    case NoProcess
    
    /// Interrupted system call
    case InterruptedSystemCall
    
    /// Input/output error
    case InputOutput
    
    /// Device not configured
    case DeviceNotConfigured
    
    /// Argument list too long
    case BigArgumentList
    
    /// Exec format error
    case ExecutableFormatError
    
    /// Bad file descriptor
    case BadFileDescriptor
    
    /// No child processes
    case NoChildProcesses
    
    /// Resource deadlock avoided
    case ResourceDeadlockAvoided
    
    /// Cannot allocate memory
    case NoMemory
    
    /// Permission Denied
    case PermissionDenied
    
    /// Bad address
    case BadAddress
    
    /// Block device required
    ///
    /// This error indicates that a nonblock file was specified where a block device was required, for example, in mount.
    case BlockDeviceRequired
    
    /// Device / Resource busy
    case Busy
    
    /// File exists
    case FileExists
    
    /// Cross-device link
    case CrossDeviceLink
    
    /// Operation not supported by device
    case OperationNotSupported
    
    /// Not a directory
    case NotDirectory
    
    /// Is a directory
    case IsDirectory
    
    /// Invalid Argument
    case InvalidArgument
    
    /// Too many open files in system
    case TooManyOpenFilesInSystem
    
    /// Too many open files
    case TooManyOpenFiles
    
    /// Inappropriate I/O control operation
    ///
    /// Also known as 'Not a typewriter' error
    case InappropriateIOControl
    
    /// Text file busy
    case TextFileBusy
    
    /// File too large
    case FileTooLarge
    
    /// No space left on device
    case NoSpace
    
    /// Illegal seek
    case IllegalSeek
}


