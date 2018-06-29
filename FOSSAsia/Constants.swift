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
        static let dataJsonKey = "data"
        static let attributesJsonKey = "attributes"
        static let emailJsonKey = "email"
        static let passwordJsonKey = "password"
        static let typeJsonKey = "type"
        static let userJsonValue = "user"

        static let acessToken = "acessToken"

    }

    struct Url {
        static let registerUrl = "https://open-event-api-dev.herokuapp.com/v1/users"

        static let loginUrl = "https://open-event-api-dev.herokuapp.com/auth/session"


    }

    struct Header {
        static let contentType = "Content-Type"

        static let contentTypeValueSignup = "application/vnd.api+json"
        static let contentTypeValueLogin = "application/json"

    }

    struct ResponseMessages {
        static let InvalidParams = "Email ID / Password incorrect"
        static let ServerError = "Problem connecting to server!"

        static let successMessageSignup = "Successfully Signed Up"
        static let successMessageLogin = "Successfully Logged In"
        static let checkParameter = "Please Check Parameters Entered"
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

    struct Location {
        static let lattitude = 1.288424
        static let longitude = 103.846694
        static let spanCoordinate = 0.0002
        static let annotationTitle = "FOSSASIA"
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
    struct MoreViewController {
        static let message = "I am using the Open Event iOS , for browsing information about the event visit https://fossasia.org/ "
        static let subject = "Check out the Open Event iOS!"
        static let Title = "Subject"
    }
}
