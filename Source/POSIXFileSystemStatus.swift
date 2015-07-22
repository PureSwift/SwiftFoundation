//
//  POSIXFileSystemStatus.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public extension statfs {
    
    // MARK: - Initialization
    
    init(path: String) throws {
        
        var fileSystemStatus = statfs()
        
        guard statfs(path, &fileSystemStatus) == 0 else {
            
            throw POSIXError.fromErrorNumber!
        }
        
        self = fileSystemStatus
    }
    
    
}