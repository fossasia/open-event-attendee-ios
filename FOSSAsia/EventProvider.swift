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
    fileprivate let dateFormatString = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    func getEvents(_ date: Date?, trackIds: [Int]?, completionHandler: @escaping EventsLoadingCompletionHandler) {
        if !SettingsManager.isKeyPresentInUserDefaults(SettingsManager.keyForEvent) {
            FetchDataService().fetchData(EventInfo.Events) { (_, error) -> Void in
                guard error == nil else {
                    let error = Error(errorCode: .networkRequestFailed)
                    completionHandler(nil, error)
                    return
                }
                
                SettingsManager.saveKeyInUserDefaults(SettingsManager.keyForEvent, bool: true)
                self.getEventsFromDisk(date, trackIds: trackIds, eventsLoadingCompletionHandler: { (events, error) -> Void in
                    guard let unwrappedEvents = events else {
                        let error = Error(errorCode: .jsonSystemReadingFailed)
                        completionHandler(nil, error)
                        return
                    }
                    
                    completionHandler(unwrappedEvents, nil)
                })
            }
        } else {
            self.getEventsFromDisk(date, trackIds: trackIds, eventsLoadingCompletionHandler: { (events, error) -> Void in
                guard let unwrappedEvents = events else {
                    let error = Error(errorCode: .jsonSystemReadingFailed)
                    completionHandler(nil, error)
                    return
                }
                
                completionHandler(unwrappedEvents, nil)
            })
        }
    }
    
    fileprivate func getEventsFromDisk(_ date: Date?, trackIds: [Int]?, eventsLoadingCompletionHandler: EventsLoadingCompletionHandler) {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first as NSString? {
            do {
                let filePath = dir.appendingPathComponent(SettingsManager.getLocalFileName(EventInfo.Events))
                let eventsData = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                let jsonObj = JSON(data: eventsData)
                guard let sessionsArray = jsonObj[EventInfo.Events.rawValue].array else {
                    let error = Error(errorCode: .jsonParsingFailed)
                    eventsLoadingCompletionHandler(nil, error)
                    return
                }
                let dateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
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
                            let sessionId = session["session_id"].string,
                            let sessionTitle = session["title"].string,
                            let sessionDescription = session["description"].string,
                            let sessionLocation = session["location"].string,
                            let sessionSpeakers = session["speakers"].array,
                            let sessionStartDateTime = session["start_time"].string,
                            let sessionEndDateTime = session["end_time"].string else {
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
                            startDateTime: dateFormatter.date(from: sessionStartDateTime)!,
                            endDateTime: dateFormatter.date(from: sessionEndDateTime)!,
                            favorite: idArray.contains(sessionId))
                        sessions.append(tempSession)
                        
                    }
                    
                    if let filterTrackIds = trackIds {
                        sessions = sessions.filter({ filterTrackIds.contains($0.trackCode.rawValue) })
                    }
                    
                    if let filterDate = date {
                        sessions = sessions.filter({ self.isSameDays(filterDate, $0.startDateTime as Date) })
                        sessions = sessions.sorted(by: { $0.startDateTime.compare($1.startDateTime as Date) == .orderedAscending })
                    }
                    
                    eventsLoadingCompletionHandler(sessions, nil)

                    
                })
            } catch {
                eventsLoadingCompletionHandler(nil, Error(errorCode: .jsonSystemReadingFailed))
            }
        }
    }
    
    fileprivate func getFavoriteEventsId(_ completionHandler: ([String]?, Error?) -> Void) {
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first as NSString? {
            let filePath = dir.appendingPathComponent(SettingsManager.favouritesLocalFileName)
            guard FileManager.default.fileExists(atPath: filePath) else {
                let tempArray: JSON = []
                if let data = tempArray.description.data(using: String.Encoding.utf8) {
                    do {
                        try data.write(to: URL(fileURLWithPath: filePath), options: .atomic)
                    } catch {
                        print(error)
                    }
                }
                completionHandler([], nil)
                return
            }
            
            do {
                let favoritesData = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                let jsonObj = JSON(data: favoritesData)
                guard let favoritesArray = jsonObj.array else {
                    let error = Error(errorCode: .jsonParsingFailed)
                    completionHandler(nil, error)
                    return
                }
                
                completionHandler(favoritesArray.map { return $0.string! }, nil)
                
            } catch {
                completionHandler(nil, Error(errorCode: .jsonSystemReadingFailed))
            }
        }
    }
    
    func toggleFavorite(_ sessionId: String, completionHandler: CommitmentCompletionHandler) {
        if let dir: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first as NSString? {
            let filePath = dir.appendingPathComponent(SettingsManager.favouritesLocalFileName)
            guard FileManager.default.fileExists(atPath: filePath) else {
                let tempArray: JSON = [sessionId]
                if let data = tempArray.description.data(using: String.Encoding.utf8) {
                    do {
                        try data.write(to: URL(fileURLWithPath: filePath), options: .atomic)
                    } catch {
                        print(error)
                    }
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
                    
                    if let data = JSON(favoriteIdArray).description.data(using: String.Encoding.utf8) {
                        do {
                            try data.write(to: URL(fileURLWithPath: filePath), options: .atomic)
                        } catch {
                            print(error)
                        }
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(error)
                }
            })
        } else {
            let error = Error(errorCode: .jsonSystemReadingFailed)
            completionHandler(error)
        }
    }
    
    fileprivate func isSameDays(_ date1:Date, _ date2:Date) -> Bool {
        let calendar = Calendar.current
        let comps1 = (calendar as NSCalendar).components([NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.day], from:date1)
        let comps2 = (calendar as NSCalendar).components([NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.day], from:date2)
        
        return (comps1.day == comps2.day) && (comps1.month == comps2.month) && (comps1.year == comps2.year)
    }
}
