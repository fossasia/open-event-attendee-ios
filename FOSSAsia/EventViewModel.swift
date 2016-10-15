//
//  EventViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation


typealias EventViewModelCompletionHandler = (EventViewModel?, Error?) -> ()

protocol EventTypePresentable {
    var typeColor: UIColor {get}
}

protocol EventDetailsPresentable {
    var eventName: String {get}
    var speakerNames: String {get}
    var timing: String {get}
    var isFavorite: Bool {get}
}

protocol EventDescriptionPresentable {
    var eventDescription: String {get }
}

protocol EventAddToCalendarPresentable {
    var eventStartTime: String {get}
    var eventEndTime: String {get}
    var eventDay: String {get}
    var eventDate: String {get}
    var eventMonth: String {get}
    var eventStartDate: Date {get}
    var eventEndDate: Date {get}
}

struct EventViewModel: EventTypePresentable, EventDetailsPresentable, EventDescriptionPresentable, EventAddToCalendarPresentable {
    let sessionId: Observable<String>
    let track: Observable<UIColor>
    let title: Observable<String>
    let shortDescription: Observable<String>
    let speakers: Observable<[Speaker]?>
    let location: Observable<String>
    let startDateTime: Observable<Date>
    let endDateTime: Observable<Date>
    let favorite: Observable<Bool>
    
    // MARK: - Services
    fileprivate var eventsService: EventProvider
    
    init (_ event: Event) {
        sessionId = Observable(event.id)
        track = Observable(event.trackCode.getTrackColor())
        title = Observable(event.title)
        shortDescription = Observable(event.shortDescription)
        speakers = Observable(event.speakers)
        location = Observable(event.location)
        startDateTime = Observable(event.startDateTime)
        endDateTime = Observable(event.endDateTime)
        favorite = Observable(event.favorite)
    
        // Dependency Injections
        eventsService = EventProvider()
    }
    
    func favoriteEvent(_ completionHandler: @escaping EventViewModelCompletionHandler) {
        eventsService.toggleFavorite(self.sessionId.value) { (error) -> Void in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            self.updateFavorite()
            completionHandler(self, nil)
        }
    }
    
    
    fileprivate func updateFavorite() {
        favorite.value = !favorite.value
        if !favorite.value {
            createLocalNotification()
        } else {
            cancelLocalNotification()
        }
    }
    
    fileprivate func createLocalNotification() {
        let localNotification = UILocalNotification()
        localNotification.fireDate = (self.startDateTime.value as NSDate).addingMinutes(-15)
        localNotification.alertBody = "\(self.title) starts in 15 minutes at \(location)!"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.userInfo = ["sessionID": sessionId.value]
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    fileprivate func cancelLocalNotification() {
        if let notifications = UIApplication.shared.scheduledLocalNotifications {
            for notification in notifications {
                if let info = notification.userInfo as? [String: String] {
                    if info["sessionID"] == sessionId.value {
                        UIApplication.shared.cancelLocalNotification(notification)
                    }
                }
            }
        }
     }
}

// MARK: - EventDescriptionPresentable Conformance
extension EventViewModel {
    var eventDescription: String { return shortDescription.value }
}

// MARK: - TypePresentable Conformance
extension EventViewModel {
    var typeColor: UIColor { return self.track.value }
}

// MARK: - EventPresentable Conformance
extension EventViewModel {
    var eventName: String { return self.title.value }
    var speakerNames: String {
        let speakers = self.speakers.value
        var speakersNames: [String] = []
        for speaker in speakers! {
            speakersNames.append(speaker.name)
        }
        return speakersNames.joined(separator: ", ")
    }
    var timing: String {
        let startTime = (self.startDateTime.value as NSDate).formattedDate(withFormat: "HH:mm")
        let endTime = (self.endDateTime.value as NSDate).formattedDate(withFormat: "HH:mm")
        return  "\(startTime) - \(endTime) - \(self.location.value)"
    }
    var isFavorite: Bool { return self.favorite.value }
}

// MARK: - EventAddToCalendar Conformance
extension EventViewModel {
    var eventStartTime: String { return (self.startDateTime.value as NSDate).formattedDate(withFormat: "HH:mm") }
    var eventEndTime: String { return (self.endDateTime.value as NSDate).formattedDate(withFormat: "HH:mm") }
    var eventDate: String { return (self.startDateTime.value as NSDate).formattedDate(withFormat: "dd") }
    var eventDay: String { return (self.startDateTime.value as NSDate).formattedDate(withFormat: "EEEE") }
    var eventMonth: String { return (self.startDateTime.value as NSDate).formattedDate(withFormat: "MMM") }
    var eventStartDate: Date { return self.startDateTime.value }
    var eventEndDate: Date { return self.endDateTime.value }
}
