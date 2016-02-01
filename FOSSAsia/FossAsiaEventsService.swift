//
//  FossAsiaEventsService.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 1/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias EventsRetrievalCompletionHandler = (Error?) -> Void

struct FossAsiaEventsService: EventsServiceProtocol {
    private let urlPath = "https://raw.githubusercontent.com/fossasia/open-event/master/testapi/"
    private let localEventsPath = "events.json"

    
    func retrieveEventsInfo(completionHandler: EventCompletionHandler) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("HasInitialLoad")) {
            self.getEventsFromNetwork { (error) -> Void in
                if error != nil {
                    completionHandler(nil, error)
                }
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(true, forKey: "HasInitialLoad")
            }
        }
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
        
            do {
                let filePath = NSURL(string: dir.stringByAppendingString(self.localEventsPath))
                let eventsData = try NSData(contentsOfURL: filePath!, options: .DataReadingMappedIfSafe)
                
                let jsonObj = JSON(data: eventsData)
                print(jsonObj)
                
            } catch {
                completionHandler(nil, Error(errorCode: .JSONSystemReadingFailed))
            }
            
        }

    }
    
    private func getEventsFromNetwork(completionHandler: EventsRetrievalCompletionHandler) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        
        let url = urlPath + "event/1/sessions"
        let request = NSURLRequest(URL: NSURL(string: url)!)
        let task  = session.dataTaskWithRequest(request) { (data, response, networkError) -> Void in
            if networkError != nil {
                let error = Error(errorCode: .NetworkRequestFailed)
                completionHandler(error)
            }
            
            guard let unwrappedData = data else {
                let error = Error(errorCode: .JSONSerializationFailed)
                completionHandler(error)
                return
            }
            
            if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                let path = dir.stringByAppendingPathComponent(self.localEventsPath);
                
                unwrappedData.writeToFile(path, atomically: false)
                
            }
        }
        
        task.resume()
    }
}