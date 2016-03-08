//
//  ApiClient.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

typealias ApiRequestCompletionHandler = (NSData?, Error?) -> Void

struct ApiClient {
    static let url = "https://raw.githubusercontent.com/fossasia/open-event-scraper/master/out/"
    
    let eventInfo: EventInfo

    func sendGetRequest(completionHandler: ApiRequestCompletionHandler) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        let request = NSURLRequest(URL: NSURL(string: getUrl(eventInfo))!)
        let task = session.dataTaskWithRequest(request) { (data, response, networkError) -> Void in
            if let _ = networkError {
                let error = Error(errorCode: .NetworkRequestFailed)
                completionHandler(nil, error)
                return
            }

            guard let unwrappedData = data else {
                let error = Error(errorCode: .JSONSerializationFailed)
                completionHandler(nil, error)
                return
            }
            
            self.processResponse(unwrappedData, completionHandler: { (error) -> Void in
                guard error == nil else {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(unwrappedData, nil)
            })
            
        }
        task.resume()
    }

    private func getUrl(eventInfo: EventInfo) -> String {
       return ApiClient.url + eventInfo.rawValue + ".json"
    }
    
    private func processResponse(data: NSData, completionHandler: CommitmentCompletionHandler) {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(SettingsManager.getLocalFileName(eventInfo));
            data.writeToFile(path, atomically: false)
            completionHandler(nil)
        }
        completionHandler(Error(errorCode: .JSONSystemReadingFailed))
    }

}