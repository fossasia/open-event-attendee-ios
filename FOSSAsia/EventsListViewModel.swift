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
    var isFavoritesOnly: Observable<Bool> = Observable(false)

    
    // MARK: - Errors
    let hasError: Observable<Bool>
    let errorMessage: Observable<String?>
    
    // MARK: - Services
    fileprivate var eventsService: EventProvider

    
    init () {
        hasError = Observable(false)
        errorMessage = Observable(nil)
        
        self.count = Observable(1)
        
        // Dependency Injections
        eventsService = EventProvider()
        
        refreshDates()
    }
    
    func refreshDates() {
        // Retrieve all dates
        eventsService.getEvents(nil, trackIds: nil) { (events, error) -> Void in
            if let eventsArray = events {
                var dates = Set<Date>()
                for event in eventsArray {
                    let newDate = NSDate(year: (event.startDateTime as NSDate).year(), month: (event.startDateTime as NSDate).month(), day: (event.startDateTime as NSDate).day())
                    dates.insert(newDate as! Date)
                }
                let sortedDates = dates.sorted(by: {$0.compare($1) == .orderedAscending})
                self.update(self.retrieveSchedule(sortedDates))
            }
        }
    }
    
    mutating func setFavoritesOnly(_ isFavoritesOnly: Bool) {
        self.isFavoritesOnly = Observable(true)
        refreshDates()
    }
    
    fileprivate func update(_ allSchedule: [ScheduleViewModel]) {
        self.allSchedules.value = allSchedule
        self.count.value = allSchedule.count
    }
    
    fileprivate func retrieveSchedule(_ dates: [Date]) -> [ScheduleViewModel] {
        let allSchedules = dates.map { date in
            return ScheduleViewModel(date, favoritesOnly: (isFavoritesOnly.value ? true : false))
        }
        return allSchedules
    }

}
