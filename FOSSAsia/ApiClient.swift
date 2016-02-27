//
//  ApiClient.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct ApiClient: Api {

    static let url = "https://raw.githubusercontent.com/fossasia/open-event/master/testapi/event/1/"

    let type: Type

    func sendGetRequest(completionHandler: CommitmentCompletionHandler) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        let request = NSURLRequest(URL: NSURL(string: getUrl(type))!)
        let task = session.dataTaskWithRequest(request) { (data, response, networkError) -> Void in
            if (networkError != nil) {
                let error = Error(errorCode: .NetworkRequestFailed)
                completionHandler(error)
            }
            guard let unwrappedData = data else {
                let error = Error(errorCode: .JSONSerializationFailed)
                completionHandler(error)
                return
            }
            if !self.processResponse(unwrappedData) {
                let error = Error(errorCode: .WritingOnDiskFailed)
                completionHandler(error)
            }
            completionHandler(nil)
        }
        task.resume()
    }

    func processResponse(data: NSData) -> Bool {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = dir.stringByAppendingPathComponent(SettingsManager.getLocalFileName(type));
            return data.writeToFile(path, atomically: false)
        }
        return false
    }

    private func getUrl(type: Type) -> String {
       return ApiClient.url + type.rawValue
    }

}