//
//  EventViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

typealias EventCellWithTypePresentable = protocol<TypePresentable, EventPresentable>

protocol TypePresentable {
    var typeColor: UIColor {get}
}

protocol EventPresentable {
    var eventName: String {get}
    var timing: String {get}
}

struct EventViewModel: EventCellWithTypePresentable {
    let track: Observable<String>
    let title: Observable<String>
    let shortDescription: Observable<String>
    let speaker: Observable<Speaker?>
    let location: Observable<String>
    let dateTime: Observable<NSDate>
    
    init (_ event: Event) {
        track = Observable(event.trackCode.rawValue)
        title = Observable(event.title)
        shortDescription = Observable(event.shortDescription)
        speaker = Observable(event.speaker)
        location = Observable(event.location)
        dateTime = Observable(event.dateTime)
    }
}


// MARK: - TypePresentable Conformance
extension EventViewModel {
    var typeColor: UIColor { return UIColor(hexString: self.track.value)! }
}

// MARK: - EventPresentable Conformance
extension EventViewModel {
    var eventName: String { return self.title.value }
    var timing: String { return "09:00AM - 10:00AM - Biopolis Hub" }
}