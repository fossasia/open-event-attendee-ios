//
//  Events.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct FetchDateService {
    
    func fetchData(eventInfo: EventInfo, completionHandler: CommitmentCompletionHandler) {
        let apiClient = ApiClient(eventInfo: eventInfo)
        apiClient.sendGetRequest { (error) -> Void in
            if let _ = error {
                completionHandler(error)
                return
            }
            completionHandler(nil)
        }
    }
}