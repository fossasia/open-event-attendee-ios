//
//  Events.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct FetchDataService {
    
    func fetchData(_ eventInfo: EventInfo, completionHandler: @escaping ApiRequestCompletionHandler) {
        let apiClient = ApiClient(eventInfo: eventInfo)
        apiClient.sendGetRequest { (data, error) -> Void in
            guard let unwrappedData = data else {
                completionHandler(nil, error)
                return
            }
            completionHandler(unwrappedData, nil)
        }
    }
}
