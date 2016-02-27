//
//  Events.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct FetchDateService {
    
    func fetchData(type: Type, completionHandler: CommitmentCompletionHandler) {
        let apiClient = ApiClient(type: type)
        apiClient.sendGetRequest { (error) -> Void in
            if (error != nil) {
                completionHandler(error)
            }
            completionHandler(nil)
        }
    }
}