//
//  RangeExtension.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 5/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

protocol ArrayRepresentable {
    typealias ArrayType
    
    func toArray() -> [ArrayType]
}

extension Range : ArrayRepresentable {
    func toArray() -> [Element] {
        return [Element](self)
    }
}