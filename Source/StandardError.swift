//
//  StandardError.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/19/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

/// Standard POSIX Errors
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
    
    // MARK: - Initialization
    
    /// Creates error from ```errno```.
    public func fromErrorNumber() -> StandardError? {
        
        switch errno {
            
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
            
        default: return nil
        }
    }
}