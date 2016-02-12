//
//  ScheduleViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 1/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

protocol ScheduleCountPresentable {
    var count: Int {get}
}

struct ScheduleViewModel: ScheduleCountPresentable {
    // MARK: - Properties
    let date: Observable<NSDate>
    let events: Observable<[EventViewModel]>
    
    let isFavoritesOnly: Observable<Bool>
    
    // MARK: - Errors
    let hasError: Observable<Bool>
    let errorMessage: Observable<String?>
    
    // MARK: - Services
    private var eventsService: EventsServiceProtocol
    
    init (_ date: NSDate, favoritesOnly: Bool = false) {
        hasError = Observable(false)
        errorMessage = Observable(nil)
        
        self.date = Observable(date)
        self.events = Observable([])
        self.isFavoritesOnly = Observable(favoritesOnly)
        
        // Dependency Injections
        eventsService = FossAsiaEventsService()
        self.refresh()
    }

    
    func refresh() {
        if let filteredTracks = NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaultsKey.FilteredTrackIds) as? [Int] {
            eventsService.retrieveEventsInfo(date.value, trackIds: filteredTracks) { (events, error) -> Void in
                if error == nil {
                    if var eventsArray = events {
                        if self.isFavoritesOnly.value {
                            eventsArray = eventsArray.filter({ $0.favorite })
                        }
                        self.update(Schedule(date: self.date.value, events: eventsArray))
                    }
                }
            }
        }
    }
    
    func favoriteEvent(sessionId: Int) {
        eventsService.toggleFavorite(sessionId) { (error) -> Void in
            if error == nil {
                self.refresh()
            }
        }
    }
    
    private func update(schedule: Schedule) {
        let tempEvents = schedule.events.map { event in
            return EventViewModel(event)
        }
        events.value = tempEvents
    }
    
    private func update(error: Error) {
        hasError.value = true
        
        switch error.errorCode {
        case .URLError:
            errorMessage.value = "The events service is not working."
        case .NetworkRequestFailed:
            errorMessage.value = "The network appears to be down."
        case .JSONSerializationFailed:
            errorMessage.value = "We're having trouble processing events data."
        case .JSONParsingFailed:
            errorMessage.value = "We're having trouble parsing events data."
        case .JSONSystemReadingFailed:
            errorMessage.value = "There seems to be a problem with reading data from disk."
        }
        
        self.events.value = []
    }

}

// MARK :- ScheduleCountPresentableConformance
extension ScheduleViewModel {
    var count: Int { return self.events.value.count }
}