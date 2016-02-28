//
//  FossAsiaAPI.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 28/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct FossAsiaAPI {
    private let urlPath = "https://raw.githubusercontent.com/fossasia/open-event/master/testapi/"
    
    func getEventsFromNetwork(completionHandler: APINetworkCompletionHandler) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        let url = urlPath + "event/1/sessions"
        let request = NSURLRequest(URL: NSURL(string: url)!)
        let task  = session.dataTaskWithRequest(request) { (data, response, networkError) -> Void in
            if networkError != nil {
                let error = Error(errorCode: .NetworkRequestFailed)
                completionHandler(nil, error)
            }
            
            guard let unwrappedData = data else {
                let error = Error(errorCode: .JSONSerializationFailed)
                completionHandler(nil, error)
                return
            }
            
            completionHandler(unwrappedData, nil)
        }
        
        task.resume()
    }
}