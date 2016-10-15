//
//  Error.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 1/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct Error {
    enum Code: Int {
        case urlError                 = -6000
        case networkRequestFailed     = -6001
        case jsonSerializationFailed  = -6002
        case jsonParsingFailed        = -6003
        case jsonSystemReadingFailed  = -6004
        case writingOnDiskFailed      = -6005
    }
    
    let errorCode: Code
}
