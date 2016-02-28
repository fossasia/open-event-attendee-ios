//
//  FossAsiaEventsService.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 1/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias EventsServiceCommitmentCompletionHandler = (Error?) -> Void
typealias APINetworkCompletionHandler =  (NSData?, Error?) -> Void

struct FossAsiaEventsService: EventsServiceProtocol {
    private let urlPath = "https://raw.githubusercontent.com/fossasia/open-event/master/testapi/"
    private let localEventsPath = "events.json"
    private let localFavoritesPath = "faves.json"
    private let dateFormatString = "yyyy-MM-dd'T'HH:mm:ss"
    
    func retrieveEventsInfo(date: NSDate?, trackIds: [Int]?, completionHandler: EventCompletionHandler) {
        if (!NSUserDefaults.standardUserDefaults().boolForKey("HasInitialLoad")) {
            self.getEventsFromNetwork { (error) -> Void in
                if error != nil {
                    completionHandler(nil, error)
                }
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(true, forKey: "HasInitialLoad")
                self.getEventsFromDisk(date, trackIds: trackIds, completionHandler: { (events, error) -> Void in
                    if let eventsFromDisk = events {
                        completionHandler(eventsFromDisk, nil)
                    } else {
                        completionHandler(nil, error)
                    }
                })
            }
        }
        
        self.getEventsFromDisk(date, trackIds: trackIds, completionHandler: { (events, error) -> Void in
            if let eventsFromDisk = events {
                completionHandler(eventsFromDisk, nil)
            } else {
                completionHandler(nil, error)
            }
        })
    }
    
    func toggleFavorite(sessionId: Int, completionHandler: EventsServiceCommitmentCompletionHandler) {
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
            let filePath = dir.stringByAppendingPathComponent(localFavoritesPath)
            guard NSFileManager.defaultManager().fileExistsAtPath(filePath) else {
                let tempArray: JSON = [sessionId]
                if let data = tempArray.description.dataUsingEncoding(NSUTF8StringEncoding) {
                    data.writeToFile(filePath, atomically: false)
                }
                completionHandler(nil)
                return
            }
            
            getFavoriteEventsId({ (favoriteIds, error) -> Void in
                if var favoriteIdArray = favoriteIds {
                    if favoriteIdArray.contains(sessionId) {
                        favoriteIdArray = favoriteIdArray.filter( {$0 != sessionId} )
                    } else {
                        favoriteIdArray.append(sessionId)
                    }
                    
                    if let data = JSON(favoriteIdArray).description.dataUsingEncoding(NSUTF8StringEncoding) {
                        data.writeToFile(filePath, atomically: false)
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(error)
                }
            })
            
        } else {
            let error = Error(errorCode: .JSONSystemReadingFailed)
            completionHandler(error)
        }
    }
    
    private func getFavoriteEventsId(completionHandler: ([Int]?, Error?) -> Void) {
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
            let filePath = dir.stringByAppendingPathComponent(localFavoritesPath)
            guard NSFileManager.defaultManager().fileExistsAtPath(filePath) else {
                let tempArray: JSON = []
                if let data = tempArray.description.dataUsingEncoding(NSUTF8StringEncoding) {
                    data.writeToFile(filePath, atomically: false)
                }
                completionHandler([], nil)
                return
            }
            
            do {
                let favoritesData = try NSData(contentsOfFile: filePath, options: .DataReadingMappedIfSafe)
                let jsonObj = JSON(data: favoritesData)
                guard let favoritesArray = jsonObj.array else {
                    let error = Error(errorCode: .JSONParsingFailed)
                    completionHandler(nil, error)
                    return
                }

                
                completionHandler(favoritesArray.map { return $0.int! }, nil)
                
            } catch {
                completionHandler(nil, Error(errorCode: .JSONSystemReadingFailed))
            }
            
            
        }
    }
    
    private func getEventsFromDisk(date: NSDate?, trackIds: [Int]?, completionHandler: EventCompletionHandler) {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
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
                
                getFavoriteEventsId({ (favoriteIds, error) -> Void in
                    guard let idArray = favoriteIds else  {
                        completionHandler(nil, error)
                        return
                    }
                    
                    for session in sessionsArray {
                        guard let trackId = session["track"].int,
                            sessionId = session["id"].int,
                            sessionTitle = session["title"].string,
                            sessionDescription = session["description"].string,
                            sessionSpeakers = session["speakers"].array,
                            sessionStartDateTime = session["begin"].string,
                            sessionEndDateTime = session["end"].string else {
                                continue
                        }
                        
                        var sessionSpeakersNames: [Speaker] = []
                        for speaker in sessionSpeakers {
                            let name = speaker["name"].string!
                            sessionSpeakersNames.append(Speaker(name: name))
                        }
                        
                        // FIX ME: - Location is hardcoded for now
                        let tempSession = Event(id: sessionId,
                            trackCode: Event.Track(rawValue: trackId)!,
                            title: sessionTitle,
                            shortDescription: sessionDescription,
                            speakers: sessionSpeakersNames,
                            location: "Biopolis Matrix",
                            startDateTime: NSDate(string: sessionStartDateTime, formatString: self.dateFormatString),
                            endDateTime: NSDate(string: sessionEndDateTime, formatString: self.dateFormatString),
                            favorite: idArray.contains(sessionId))
                        sessions.append(tempSession)
                    }
                    
                    if let filterTrackIds = trackIds {
                        sessions = sessions.filter({ filterTrackIds.contains($0.trackCode.rawValue) })
                    }
                    
                    if let filterDate = date {
                        sessions = sessions.filter({ filterDate.daysFrom($0.startDateTime) == 0 })
                    }
                })
                
                
                
                completionHandler(sessions, nil)
            } catch {
                completionHandler(nil, Error(errorCode: .JSONSystemReadingFailed))
            }
        }
    }
    
    private func getEventsFromNetwork(completionHandler: EventsServiceCommitmentCompletionHandler) {
        let api = FossAsiaAPI()
        api.getEventsFromNetwork { (data, error) -> Void in
            if error != nil {
                completionHandler(error)
            }
            
            if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
                let path = dir.stringByAppendingPathComponent(self.localEventsPath);
                
                data!.writeToFile(path, atomically: false)
                completionHandler(nil)
            }
        }
    }
}