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
    let date: Observable<NSDate>
    let sessions: Observable<[SessionViewModel]>
    
    let isFavoritesOnly: Observable<Bool>
    
    // MARK: - Errors
    let hasError: Observable<Bool>
    let errorMessage: Observable<String?>
    
    // MARK: - Services
    private var sessionsService: SessionProvider
    
    init (_ date: NSDate, favoritesOnly: Bool = false) {
        hasError = Observable(false)
        errorMessage = Observable(nil)
        
        self.date = Observable(date)
        self.sessions = Observable([])
        self.isFavoritesOnly = Observable(favoritesOnly)
        
        // Dependency Injections
        sessionsService = SessionProvider()
        self.refresh()
    }
    
    
    func refresh() {
        if let filteredTracks = NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaultsKey.FilteredTrackIds) as? [Int] {
            sessionsService.getSessions(date.value, trackIds: filteredTracks) { (sessions, error) -> Void in
                guard let unwrappedSessions = sessions else {
                    self.delegate?.scheduleDidLoad(nil, error: error)
                    return
                }
                
                var sessionsArray: [Session] = unwrappedSessions
                if self.isFavoritesOnly.value {
                    sessionsArray = sessionsArray.filter({ $0.favorite })
                }
                
                self.update(Schedule(date: self.date.value, sessions: sessionsArray))
            }
        }
    }
    
    private func update(schedule: Schedule) {
        let tempSessions = schedule.sessions.map { session in
            return SessionViewModel(session)
        }
        sessions.value = tempSessions
        self.delegate?.scheduleDidLoad(schedule, error: nil)
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
        case .WritingOnDiskFailed:
            errorMessage.value = "There seems to be a problem with writing data on disk."
        }
        
        self.sessions.value = []
    }
    
}

// MARK :- ScheduleCountPresentableConformance
extension ScheduleViewModel {
    var count: Int { return self.sessions.value.count }
}