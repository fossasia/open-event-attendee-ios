//
//  Api.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

typealias CommitmentCompletionHandler = (Error?) -> Void

protocol ApiProtocol {
    func sendGetRequest(completionHandler: CommitmentCompletionHandler)
    func processResponse(data: NSData) -> Bool
}