//
//  SessionViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation


typealias SessionViewModelCompletionHandler = (SessionViewModel?, Error?) -> ()

protocol SessionTypePresentable {
    var typeColor: UIColor {get}
}

protocol SessionDetailsPresentable {
    var sessionName: String {get}
    var speakerNames: String {get}
    var timing: String {get}
    var isFavorite: Bool {get}
}

protocol SessionDescriptionPresentable {
    var sessionDescription: String {get }
}

protocol SessionAddToCalendarPresentable {
    var sessionStartTime: String {get}
    var sessionEndTime: String {get}
    var sessionDay: String {get}
    var sessionDate: String {get}
    var sessionMonth: String {get}
    var sessionStartDate: NSDate {get}
    var sessionEndDate: NSDate {get}
}

struct SessionViewModel: SessionTypePresentable, SessionDetailsPresentable, SessionDescriptionPresentable, SessionAddToCalendarPresentable {
    let sessionId: Observable<String>
    let track: Observable<UIColor>
    let title: Observable<String>
    let shortDescription: Observable<String>
    let speakers: Observable<[Speaker]?>
    let location: Observable<String>
    let startDateTime: Observable<NSDate>
    let endDateTime: Observable<NSDate>
    let favorite: Observable<Bool>
    
    // MARK: - Services
    private var sessionsService: SessionProvider
    
    init (_ session: Session) {
        sessionId = Observable(session.id)
        track = Observable(session.trackCode.getTrackColor())
        title = Observable(session.title)
        shortDescription = Observable(session.shortDescription)
        speakers = Observable(session.speakers)
        location = Observable(session.location)
        startDateTime = Observable(session.startDateTime)
        endDateTime = Observable(session.endDateTime)
        favorite = Observable(session.favorite)
    
        // Dependency Injections
        sessionsService = SessionProvider()
    }
    
    func favoriteSession(completionHandler: SessionViewModelCompletionHandler) {
        sessionsService.toggleFavorite(self.sessionId.value) { (error) -> Void in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            self.updateFavorite()
            completionHandler(self, nil)
        }
    }
    
    
    private func updateFavorite() {
        favorite.value = !favorite.value
        if !favorite.value {
            createLocalNotification()
        } else {
            cancelLocalNotification()
        }
    }
    
    private func createLocalNotification() {
        let localNotification = UILocalNotification()
        localNotification.fireDate = self.startDateTime.value.dateByAddingMinutes(-15)
        localNotification.alertBody = "\(self.title) starts in 15 minutes at \(location)!"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.userInfo = ["sessionID": sessionId.value]
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    private func cancelLocalNotification() {
        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            for notification in notifications {
                if let info = notification.userInfo as? [String: String] {
                    if info["sessionID"] == sessionId.value {
                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                    }
                }
            }
        }
     }
}

// MARK: - SessionDescriptionPresentable Conformance
extension SessionViewModel {
    var sessionDescription: String { return shortDescription.value }
}

// MARK: - TypePresentable Conformance
extension SessionViewModel {
    var typeColor: UIColor { return self.track.value }
}

// MARK: - SessionPresentable Conformance
extension SessionViewModel {
    var sessionName: String { return self.title.value }
    var speakerNames: String {
        let speakers = self.speakers.value
        var speakersNames: [String] = []
        for speaker in speakers! {
            speakersNames.append(speaker.name)
        }
        return speakersNames.joinWithSeparator(", ")
    }
    var timing: String {
        let startTime = self.startDateTime.value.formattedDateWithFormat("HH:mm")
        let endTime = self.endDateTime.value.formattedDateWithFormat("HH:mm")
        return  "\(startTime) - \(endTime) - \(self.location.value)"
    }
    var isFavorite: Bool { return self.favorite.value }
}

// MARK: - SessionAddToCalendar Conformance
extension SessionViewModel {
    var sessionStartTime: String { return self.startDateTime.value.formattedDateWithFormat("HH:mm") }
    var sessionEndTime: String { return self.endDateTime.value.formattedDateWithFormat("HH:mm") }
    var sessionDate: String { return self.startDateTime.value.formattedDateWithFormat("dd") }
    var sessionDay: String { return self.startDateTime.value.formattedDateWithFormat("EEEE") }
    var sessionMonth: String { return self.startDateTime.value.formattedDateWithFormat("MMM") }
    var sessionStartDate: NSDate { return self.startDateTime.value }
    var sessionEndDate: NSDate { return self.endDateTime.value }
}