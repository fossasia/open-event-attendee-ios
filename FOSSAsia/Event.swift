//
//  Event.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct Event {
    enum Track: String {
        case General = "8E8E93"
        case OpenTech = "FF4D55"
        case DevOps = "FF8C2F"
        case Web = "FFD233"
        case Python = "6CBD7A"
        case Mozilla = "3DC8C3"
        case Exhibition = "39A8FA"
        case Workshops = "B26DE0"
    }
    
    let trackCode: Track
    let title: String
    let shortDescription: String
    let speaker: Speaker?
    let location: String
    let startDateTime: NSDate
    let endDateTime: NSDate
    let favorite: Bool = false
}