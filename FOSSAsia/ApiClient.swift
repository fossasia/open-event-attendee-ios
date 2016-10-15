//
//  ApiClient.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

typealias ApiRequestCompletionHandler = (Data?, Error?) -> Void

struct ApiClient {
//    static let url = "https://raw.githubusercontent.com/fossasia/open-event/master/testapi/event/1/"
    static let url = "https://raw.githubusercontent.com/fossasia/2016.fossasia.org/gh-pages/schedule/"
    
    let eventInfo: EventInfo

    func sendGetRequest(_ completionHandler: @escaping ApiRequestCompletionHandler) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: URL(string: getUrl(eventInfo))!)
        let task = session.dataTask(with: request, completionHandler: { (data, response, networkError) -> Void in
            if let _ = networkError {
                let error = Error(errorCode: .networkRequestFailed)
                completionHandler(nil, error)
                return
            }

            guard let unwrappedData = data else {
                let error = Error(errorCode: .jsonSerializationFailed)
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
            
        }) 
        task.resume()
    }

    fileprivate func getUrl(_ eventInfo: EventInfo) -> String {
       return ApiClient.url + eventInfo.rawValue + ".json"
    }
    
    fileprivate func processResponse(_ data: Data, completionHandler: CommitmentCompletionHandler) {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
            let path = dir.appendingPathComponent(SettingsManager.getLocalFileName(eventInfo));
            try? data.write(to: URL(fileURLWithPath: path), options: [])
            completionHandler(nil)
        }
        completionHandler(Error(errorCode: .jsonSystemReadingFailed))
    }

}
