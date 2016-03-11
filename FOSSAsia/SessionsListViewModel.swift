//
//  SessionsListViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 10/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct SessionsListViewModel {
    //MARK:- Properties
    let allSchedules: Observable<[ScheduleViewModel]> = Observable([])
    let count: Observable<Int>
    var isFavoritesOnly: Observable<Bool> = Observable(false)

    
    // MARK: - Errors
    let hasError: Observable<Bool>
    let errorMessage: Observable<String?>
    
    // MARK: - Services
    private var sessionsService: SessionProvider

    
    init () {
        hasError = Observable(false)
        errorMessage = Observable(nil)
        
        self.count = Observable(1)
        
        // Dependency Injections
        sessionsService = SessionProvider()
        
        refreshDates()
    }
    
    func refreshDates() {
        // Retrieve all dates
        sessionsService.getSessions(nil, trackIds: nil) { (sessions, error) -> Void in
            if let sessionsArray = sessions {
                var dates = Set<NSDate>()
                for session in sessionsArray {
                    let newDate = NSDate(year: session.startDateTime.year(), month: session.startDateTime.month(), day: session.startDateTime.day())
                    dates.insert(newDate)
                }
                let sortedDates = dates.sort({$0.compare($1) == .OrderedAscending})
                self.update(self.retrieveSchedule(sortedDates))
            }
        }
    }
    
    mutating func setFavoritesOnly(isFavoritesOnly: Bool) {
        self.isFavoritesOnly = Observable(true)
        refreshDates()
    }
    
    private func update(allSchedule: [ScheduleViewModel]) {
        self.allSchedules.value = allSchedule
        self.count.value = allSchedule.count
    }
    
    private func retrieveSchedule(dates: [NSDate]) -> [ScheduleViewModel] {
        let allSchedules = dates.map { date in
            return ScheduleViewModel(date, favoritesOnly: (isFavoritesOnly.value ? true : false))
        }
        return allSchedules
    }

}