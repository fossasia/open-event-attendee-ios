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
    private let dateFormatString = "yyyy-MM-dd'T'HH:mm:ss"

    
    func retrieveEventsInfo(completionHandler: EventCompletionHandler) {
        if (!NSUserDefaults.standardUserDefaults().boolForKey("HasInitialLoad")) {
            self.getEventsFromNetwork { (error) -> Void in
                if error != nil {
                    completionHandler(nil, error)
                }
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(true, forKey: "HasInitialLoad")
                self.getEventsFromDisk { (events, error) -> Void in
                    if let eventsFromDisk = events {
                        completionHandler(eventsFromDisk, nil)
                    } else {
                        completionHandler(nil, error)
                    }
                }
            }
        }
        
        self.getEventsFromDisk { (events, error) -> Void in
            if let eventsFromDisk = events {
                completionHandler(eventsFromDisk, nil)
            } else {
                completionHandler(nil, error)
            }
        }

    }
    
    private func getEventsFromDisk(completionHandler: EventCompletionHandler) {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            do {
                let filePath = dir.stringByAppendingPathComponent(self.localEventsPath)
                let eventsData = try NSData(contentsOfFile: filePath, options: .DataReadingMappedIfSafe)
                
                let jsonObj = JSON(data: eventsData)
                guard let sessionsArray = jsonObj["sessions"].array else {
                    let error = Error(errorCode: .JSONParsingFailed)
                    completionHandler(nil, error)
                    return
                }
                
                var sessions: [Event] = []
                
                for session in sessionsArray {
                    guard let trackId = session["track"].int,
                        sessionTitle = session["title"].string,
                        sessionDescription = session["description"].string,
                        sessionSpeakerName = session["speakers"][0]["name"].string,
                        sessionStartDateTime = session["begin"].string,
                        sessionEndDateTime = session["end"].string else {
                            continue
                    }
                    
                    
                    let tempSession = Event(trackCode: Event.Track(rawValue: trackId)!, title:sessionTitle, shortDescription: sessionDescription, speaker: Speaker(name: sessionSpeakerName), location: "Biopolis Matrix", startDateTime: NSDate(string: sessionStartDateTime, formatString: dateFormatString), endDateTime: NSDate(string: sessionEndDateTime, formatString: dateFormatString))
                    sessions.append(tempSession)
                }
                
                completionHandler(sessions, nil)
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
            
            completionHandler(nil)
        }
        
        task.resume()
    }
}