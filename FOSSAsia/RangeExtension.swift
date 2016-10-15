//
//  RangeExtension.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 5/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

extension Sequence {
    func toArray() -> [Iterator.Element] {
        
        return Array(self)
    }
}
