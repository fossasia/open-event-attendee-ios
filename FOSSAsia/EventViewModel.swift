//
//  EventViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation


protocol EventTypePresentable {
    var typeColor: UIColor {get}
}

protocol EventDetailsPresentable {
    var eventName: String {get}
    var speakerName: String {get}
    var timing: String {get}
}

protocol EventDescriptionPresentable {
    var eventDescription: String {get }
}

struct EventViewModel: EventTypePresentable, EventDetailsPresentable, EventDescriptionPresentable {
    let track: Observable<String>
    let title: Observable<String>
    let shortDescription: Observable<String>
    let speaker: Observable<Speaker?>
    let location: Observable<String>
    let startDateTime: Observable<NSDate>
    let endDateTime: Observable<NSDate>
    let favorite: Observable<Bool>
    
    init (_ event: Event) {
        track = Observable(event.trackCode.rawValue)
        title = Observable(event.title)
        shortDescription = Observable(event.shortDescription)
        speaker = Observable(event.speaker)
        location = Observable(event.location)
        startDateTime = Observable(event.startDateTime)
        endDateTime = Observable(event.endDateTime)
        favorite = Observable(event.favorite)
    }
}

// MARK: - EventDescriptionPresentable Conformance
extension EventViewModel {
    var eventDescription: String { return shortDescription.value }
}

// MARK: - TypePresentable Conformance
extension EventViewModel {
    var typeColor: UIColor { return UIColor(hexString: self.track.value)! }
}

// MARK: - EventPresentable Conformance
extension EventViewModel {
    var eventName: String { return self.title.value }
    var speakerName: String { return (self.speaker.value?.name)! }
    var timing: String { return "09:00AM - 10:00AM - Biopolis Hub" }
}