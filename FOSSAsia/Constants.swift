//
//  Constants.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 5/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct Constants {

    static let numberOfTracks = 15
    static let jsonFileExtension = ".json"
    static let localNotificationIdentifier = "LocalNotification"
    static let sessionsStoryboardName = "Sessions"
    static let individualEventStoryboard = "IndividualEvent"
    static let eventViewControllerID = "EventViewController"
    static let okTitle = "OK"
    static let cancelTitle = "Cancel"
    static let appStoreAlertTitle = "Open App Store?"
    static let appStoreAlertMessage = "Tapping OK will temporarily exit this application and open the app's page on the App Store"

    struct UserDefaultsKey {
        static let FilteredTrackIds = "FilteredTrackIds"
    }

    struct Sessions {
        static let track = "track"
        static let id = "id"
        static let sessionId = "session_id"
        static let title = "title"
        static let description = "description"
        static let location = "location"
        static let speakers = "speakers"
        static let startTime = "start_time"
        static let endTime = "end_time"
        static let speakerName = "name"
    }

    struct SettingsManager {
        static let keyForEvent = "HasEvents"
        static let keyForMicrolocations = "HasMicrolocations"
        static let favesJSON = "faves.json"
    }

    struct Images {
        static let navbarFaveHighlighted = "navbar_fave_highlighted"
        static let navbarFave = "navbar_fave"
    }
}
