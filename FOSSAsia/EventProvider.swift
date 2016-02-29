//
//  EventProvider.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias EventsLoadingCompletionHandler = ([Event]?, Error?) -> Void

struct EventProvider {
    
    private let dateFormatString = "yyyy-MM-dd'T'HH:mm:ss"
    
    func getEvents(date: NSDate?, trackIds: [Int]?, completionHandler: EventsLoadingCompletionHandler) {
	let microlocationProvider = MicrolocationProvider()
	microlocationProvider.getMicrolocations { _,_ in }
        if !SettingsManager.isKeyPresentInUserDefaults(SettingsManager.keyForEvent) {
            FetchDateService().fetchData(EventInfo.Events) { (error) -> Void in
                if error != nil {
                    completionHandler(nil, error!)
                }
                SettingsManager.saveKeyInUserDefaults(SettingsManager.keyForEvent, bool: true)
		self.getEventsFromDisk(date, trackIds: trackIds, eventsLoadingCompletionHandler: { (events, error) -> Void in
                    if let eventsFromDisk = events {
                        completionHandler(eventsFromDisk, nil)
                    } else {
                        completionHandler(nil, error)
                    }
                });
            }
            
        }
	self.getEventsFromDisk(date, trackIds: trackIds, eventsLoadingCompletionHandler: { (events, error) -> Void in
            if let eventsFromDisk = events {
                completionHandler(eventsFromDisk, nil)
            } else {
                completionHandler(nil, error)
            }
        });
        
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

		var sessions: [Event] = []

		getFavoriteEventsId({ (favoriteIds, error) -> Void in
		    guard let idArray = favoriteIds else  {
			eventsLoadingCompletionHandler(nil, error)
                        return
                    }
                    
                    for session in sessionsArray {
                        guard let trackId = session["track"].int,
			    sessionId = session["id"].int,
			    sessionTitle = session["title"].string,
			    sessionDescription = session["description"].string,
			    sessionMicrolocationId = session["microlocation"].int,
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
                        
                        let tempSession = Event(id: sessionId,
                            trackCode: Event.Track(rawValue: trackId)!,
			    title: sessionTitle,
			    shortDescription: sessionDescription,
			    speakers: sessionSpeakersNames,
			    microlocationId: sessionMicrolocationId,
			    location: "Unable to find location",
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

		    let microlocationProvider = MicrolocationProvider()
		    microlocationProvider.getMicrolocations { (microlocations, error) -> Void in
			if error == nil {
			    if let microlocationsArray = microlocations {
				for index in 0..<sessions.count {
				    if let name = Microlocation.getNameOfMicrolocationId(sessions[index].microlocationId, microlocations: microlocationsArray) {
					sessions[index].location = name
				    }
				}
			    }
			}
			eventsLoadingCompletionHandler(sessions, nil)
		    }
		})

	    } catch {
		eventsLoadingCompletionHandler(nil, Error(errorCode: .JSONSystemReadingFailed))
            }
        }
    }
    
    private func getFavoriteEventsId(completionHandler: ([Int]?, Error?) -> Void) {
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
                
                completionHandler(favoritesArray.map { return $0.int! }, nil)
                
            } catch {
                completionHandler(nil, Error(errorCode: .JSONSystemReadingFailed))
            }
        }
    }
    
    func toggleFavorite(sessionId: Int, completionHandler: CommitmentCompletionHandler) {
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
    
}