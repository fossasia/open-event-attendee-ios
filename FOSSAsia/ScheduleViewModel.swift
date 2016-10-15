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
    weak var delegate: ScheduleViewModelDelegate?
    // MARK: - Properties
    let date: Observable<Date>
    let events: Observable<[EventViewModel]>
    
    let isFavoritesOnly: Observable<Bool>
    
    // MARK: - Errors
    let hasError: Observable<Bool>
    let errorMessage: Observable<String?>
    
    // MARK: - Services
    fileprivate var eventsService: EventProvider
    
    init (_ date: Date, favoritesOnly: Bool = false) {
        hasError = Observable(false)
        errorMessage = Observable(nil)
        
        self.date = Observable(date)
        self.events = Observable([])
        self.isFavoritesOnly = Observable(favoritesOnly)
        
        // Dependency Injections
        eventsService = EventProvider()
        self.refresh()
    }

    
    func refresh() {
        if let filteredTracks = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.FilteredTrackIds) as? [Int] {
            eventsService.getEvents(date.value, trackIds: filteredTracks) { (events, error) -> Void in
                guard let unwrappedEvents = events else {
                    self.delegate?.scheduleDidLoad(nil, error: error)
                    return
                }
                
                var eventsArray: [Event] = unwrappedEvents
                if self.isFavoritesOnly.value {
                    eventsArray = eventsArray.filter({ $0.favorite })
                }
                
                self.update(Schedule(date: self.date.value, events: eventsArray))
            }
        }
    }
    
    fileprivate func update(_ schedule: Schedule) {
        let tempEvents = schedule.events.map { event in
            return EventViewModel(event)
        }
        events.value = tempEvents
        self.delegate?.scheduleDidLoad(schedule, error: nil)
    }
    
    fileprivate func update(_ error: Error) {
        hasError.value = true
        
        switch error.errorCode {
        case .urlError:
            errorMessage.value = "The events service is not working."
        case .networkRequestFailed:
            errorMessage.value = "The network appears to be down."
        case .jsonSerializationFailed:
            errorMessage.value = "We're having trouble processing events data."
        case .jsonParsingFailed:
            errorMessage.value = "We're having trouble parsing events data."
        case .jsonSystemReadingFailed:
            errorMessage.value = "There seems to be a problem with reading data from disk."
        case .writingOnDiskFailed:
            errorMessage.value = "There seems to be a problem with writing data on disk."
        }
        
        self.events.value = []
    }

}

// MARK :- ScheduleCountPresentableConformance
extension ScheduleViewModel {
    var count: Int { return self.events.value.count }
}
