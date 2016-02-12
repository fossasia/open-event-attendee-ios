//
//  EventsListViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 10/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct EventsListViewModel {
    //MARK:- Properties
    let allSchedules: Observable<[ScheduleViewModel]> = Observable([])
    let count: Observable<Int>
    
    // MARK: - Errors
    let hasError: Observable<Bool>
    let errorMessage: Observable<String?>
    
    // MARK: - Services
    private var eventsService: EventsServiceProtocol

    
    init () {
        hasError = Observable(false)
        errorMessage = Observable(nil)
        
        self.count = Observable(1)
        
        // Dependency Injections
        eventsService = FossAsiaEventsService()
        
        refreshDates()
    }
    
    func refreshDates() {
        // Retrieve all dates
        eventsService.retrieveEventsInfo(nil, trackIds: nil) { (events, error) -> Void in
            if let eventsArray = events {
                var dates = Set<NSDate>()
                for event in eventsArray {
                    let newDate = NSDate(year: event.startDateTime.year(), month: event.startDateTime.month(), day: event.startDateTime.day())
                    dates.insert(newDate)
                }
                let sortedDates = dates.sort({$0.compare($1) == .OrderedAscending})
                self.update(self.retrieveSchedule(sortedDates))
            }
        }
    }
    
    private func update(allSchedule: [ScheduleViewModel]) {
        self.allSchedules.value = allSchedule
        self.count.value = allSchedule.count
    }
    
    private func retrieveSchedule(dates: [NSDate]) -> [ScheduleViewModel] {
        let allSchedules = dates.map { date in
            return ScheduleViewModel(date)
        }
        return allSchedules
    }

}