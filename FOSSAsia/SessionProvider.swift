//
//  SessionProvider.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias CommitmentCompletionHandler = (Error?) -> Void
typealias SessionsLoadingCompletionHandler = ([Session]?, Error?) -> Void

struct SessionProvider {
    private let dateFormatString = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    func getSessions(date: NSDate?, trackIds: [Int]?, completionHandler: SessionsLoadingCompletionHandler) {
        if !SettingsManager.isSessionDataLoaded() || SettingsManager.isRefreshAllowed() {
            FetchDataService().fetchData(EventInfo.Sessions) { (_, error) -> Void in
                guard error == nil else {
                    let error = Error(errorCode: .NetworkRequestFailed)
                    completionHandler(nil, error)
                    return
                }
                
                SettingsManager.saveKeyInUserDefaults(SettingsManager.keyForSession, bool: true)
                SettingsManager.saveKeyInUserDefaults(SettingsManager.keyForRefresh, bool: false)
                self.getSessionsFromDisk(date, trackIds: trackIds, sessionsLoadingCompletionHandler: { (sessions, error) -> Void in
                    guard let unwrappedSessions = sessions else {
                        let error = Error(errorCode: .JSONSystemReadingFailed)
                        completionHandler(nil, error)
                        return
                    }
                    
                    completionHandler(unwrappedSessions, nil)
                })
            }
        } else {
            self.getSessionsFromDisk(date, trackIds: trackIds, sessionsLoadingCompletionHandler: { (sessions, error) -> Void in
                guard let unwrappedSessions = sessions else {
                    let error = Error(errorCode: .JSONSystemReadingFailed)
                    completionHandler(nil, error)
                    return
                }
                
                completionHandler(unwrappedSessions, nil)
            })
        }
    }
    
    private func getSessionsFromDisk(date: NSDate?, trackIds: [Int]?, sessionsLoadingCompletionHandler: SessionsLoadingCompletionHandler) {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
            do {
                let filePath = dir.stringByAppendingPathComponent(SettingsManager.getLocalFileName(EventInfo.Sessions))
                let sessionsData = try NSData(contentsOfFile: filePath, options: .DataReadingMappedIfSafe)
                let jsonObj = JSON(data: sessionsData)
                guard let sessionsArray = jsonObj[EventInfo.Sessions.rawValue].array else {
                    let error = Error(errorCode: .JSONParsingFailed)
                    sessionsLoadingCompletionHandler(nil, error)
                    return
                }
                let dateFormatter: NSDateFormatter = {
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    return formatter
                }()
                
                getFavoriteSessionsId({ (favoriteIds, error) -> Void in
                    guard let idArray = favoriteIds else {
                        sessionsLoadingCompletionHandler(nil, error)
                        return
                    }
                    
                    var sessions: [Session] = []
                    guard error == nil else {
                        sessionsLoadingCompletionHandler(nil, error)
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
                        
                        let tempSession = Session(id: sessionId,
                            trackCode: Session.Track(rawValue: trackId)!,
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
                    
                    sessionsLoadingCompletionHandler(sessions, nil)
                    
                    
                })
            } catch {
                sessionsLoadingCompletionHandler(nil, Error(errorCode: .JSONSystemReadingFailed))
            }
        }
    }
    
    private func getFavoriteSessionsId(completionHandler: ([String]?, Error?) -> Void) {
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
            
            getFavoriteSessionsId({ (favoriteIds, error) -> Void in
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
