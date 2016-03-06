//
//  EventProvider.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias CommitmentCompletionHandler = (Error?) -> Void
typealias EventsLoadingCompletionHandler = ([Event]?, Error?) -> Void

struct EventProvider {
    private let dateFormatString = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    func getEvents(date: NSDate?, trackIds: [Int]?, completionHandler: EventsLoadingCompletionHandler) {
        if !SettingsManager.isKeyPresentInUserDefaults(SettingsManager.keyForEvent) {
            FetchDataService().fetchData(EventInfo.Events) { (_, error) -> Void in
                guard error == nil else {
                    let error = Error(errorCode: .NetworkRequestFailed)
                    completionHandler(nil, error)
                    return
                }
                
                SettingsManager.saveKeyInUserDefaults(SettingsManager.keyForEvent, bool: true)
                self.getEventsFromDisk(date, trackIds: trackIds, eventsLoadingCompletionHandler: { (events, error) -> Void in
                    guard let unwrappedEvents = events else {
                        let error = Error(errorCode: .JSONSystemReadingFailed)
                        completionHandler(nil, error)
                        return
                    }
                    
                    completionHandler(unwrappedEvents, nil)
                })
            }
        } else {
            self.getEventsFromDisk(date, trackIds: trackIds, eventsLoadingCompletionHandler: { (events, error) -> Void in
                guard let unwrappedEvents = events else {
                    let error = Error(errorCode: .JSONSystemReadingFailed)
                    completionHandler(nil, error)
                    return
                }
                
                completionHandler(unwrappedEvents, nil)
            })
        }
    }
    
    private func getEventsFromDisk(date: NSDate?, trackIds: [Int]?, eventsLoadingCompletionHandler: EventsLoadingCompletionHandler) {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
            do {
                let filePath = dir.stringByAppendingPathComponent(SettingsManager.getLocalFileName(EventInfo.Events))
                let eventsData = try NSData(contentsOfFile: filePath, options: .DataReadingMappedIfSafe)
                let jsonObj = JSON(data: eventsData)
                guard let sessionsArray = jsonObj[EventInfo.Events.rawValue].array else {
                    let error = Error(errorCode: .JSONParsingFailed)
                    eventsLoadingCompletionHandler(nil, error)
                    return
                }
                let dateFormatter: NSDateFormatter = {
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    return formatter
                }()
                
                getFavoriteEventsId({ (favoriteIds, error) -> Void in
                    guard let idArray = favoriteIds else {
                        eventsLoadingCompletionHandler(nil, error)
                        return
                    }
                    
                    var sessions: [Event] = []
                    guard error == nil else {
                        eventsLoadingCompletionHandler(nil, error)
                        return
                    }
                    
                    for session in sessionsArray {
                        guard let trackId = session["track"]["id"].int,
                            sessionId = session["session_id"].string,
                            sessionTitle = session["title"].string,
                            sessionDescription = session["description"].string,
                            sessionLocation = session["location"].string,
                            sessionSpeakers = session["speakers"].array,
                            sessionStartDateTime = session["start_time"].string,
                            sessionEndDateTime = session["end_time"].string else {
                                continue
                        }
                        
                        var sessionSpeakersNames: [Speaker] = []
                        
                        for speaker in sessionSpeakers {
                            guard let speakerName = speaker["name"].string else { continue }
                            let name = speakerName
                            sessionSpeakersNames.append(Speaker(name: name))
                        }
                                                
                        let tempSession = Event(id: sessionId,
                            trackCode: Event.Track(rawValue: trackId)!,
                            title: sessionTitle,
                            shortDescription: sessionDescription,
                            speakers: sessionSpeakersNames,
                            location: sessionLocation,
                            startDateTime: dateFormatter.dateFromString(sessionStartDateTime)!,
                            endDateTime: dateFormatter.dateFromString(sessionEndDateTime)!,
                            favorite: idArray.contains(sessionId))
                        sessions.append(tempSession)
                        
                    }
                    
                    if let filterTrackIds = trackIds {
                        sessions = sessions.filter({ filterTrackIds.contains($0.trackCode.rawValue) })
                    }
                    
                    if let filterDate = date {
                        sessions = sessions.filter({ self.isSameDays(filterDate, $0.startDateTime) })
                        sessions = sessions.sort({ $0.startDateTime.compare($1.startDateTime) == .OrderedAscending })
                    }
                    
                    eventsLoadingCompletionHandler(sessions, nil)

                    
                })
            } catch {
                eventsLoadingCompletionHandler(nil, Error(errorCode: .JSONSystemReadingFailed))
            }
        }
    }
    
    private func getFavoriteEventsId(completionHandler: ([String]?, Error?) -> Void) {
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
            let filePath = dir.stringByAppendingPathComponent(SettingsManager.favouritesLocalFileName)
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
                
                completionHandler(favoritesArray.map { return $0.string! }, nil)
                
            } catch {
                completionHandler(nil, Error(errorCode: .JSONSystemReadingFailed))
            }
        }
    }
    
    func toggleFavorite(sessionId: String, completionHandler: CommitmentCompletionHandler) {
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
            let filePath = dir.stringByAppendingPathComponent(SettingsManager.favouritesLocalFileName)
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
    
    private func isSameDays(date1:NSDate, _ date2:NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let comps1 = calendar.components([NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Day], fromDate:date1)
        let comps2 = calendar.components([NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Day], fromDate:date2)
        
        return (comps1.day == comps2.day) && (comps1.month == comps2.month) && (comps1.year == comps2.year)
    }
}
