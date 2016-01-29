//
//  EventViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct EventViewModel {
    let track: Observable<String>
    let title: Observable<String>
    let shortDescription: Observable<String>
    let speaker: Observable<Speaker>
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