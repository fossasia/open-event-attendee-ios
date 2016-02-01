//
//  ScheduleViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 1/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct ScheduleViewModel {
    let date: Observable<NSDate>
    let events: Observable<[EventViewModel]>
    
    init (_ date: NSDate) {
        self.date = Observable(date)
        self.events = Observable([])
    }
    
    private func update(schedule: Schedule) {
        let tempEvents = schedule.events.map { event in
            return EventViewModel(event)
        }
        events.value = tempEvents
    }
    
    func returnMockData() {
        var eventsArray: [Event] = []
        
        let event1 = Event(trackCode: .General, title:"Snacks", shortDescription: "Just saying hi", speaker: nil, location: "Biopolis Matrix", startDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 00, second: 00), endDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 30, second: 00))
        let event2 = Event(trackCode: .Mozilla, title: "Collaborative Webmaking using TogetherJS", shortDescription: "", speaker: nil, location: "JFDI Blk 71", startDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 00, second: 00), endDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 30, second: 00))
        let event3 = Event(trackCode: .DevOps, title: "oVirt Workshop", shortDescription: "", speaker: nil, location: "JFDI Blk 71", startDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 00, second: 00), endDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 30, second: 00))
        let event4 = Event(trackCode: .OpenTech, title: "Free/Libre Open Source Software Licenses", shortDescription: "", speaker: nil, location: "NUS Plug-In Blk 71", startDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 30, second: 00), endDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 50, second: 00))
        
        eventsArray.append(event1)
        eventsArray.append(event2)
        eventsArray.append(event3)
        eventsArray.append(event4)
        self.update(Schedule(date: NSDate(year: 2015, month: 03, day: 14), events: eventsArray))
        
    }
}