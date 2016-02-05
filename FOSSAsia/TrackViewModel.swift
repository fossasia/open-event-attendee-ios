//
//  TrackViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 5/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

protocol TrackDetailsPresentable {
    var trackId: Int {get}
    var trackName: String {get}
}

protocol TrackStatusPresentable {
    var isTrackOn: Bool {get}
    func changeFilterPreference(status: Bool)
}

protocol TrackColorPresentable {
    var trackColor: UIColor {get}
}

struct TrackViewModel: TrackDetailsPresentable, TrackStatusPresentable, TrackColorPresentable {
    
    // MARK: - Properties
    let isOn: Observable<Bool>
    let id: Observable<Int>
    let name: Observable<String>

    
    init(_ track: Event.Track) {
        self.id = Observable(track.rawValue)
        self.name = Observable(track.description)
        if let filteredTrackIds = NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaultsKey.FilteredTrackIds) as? [Int] {
            self.isOn = Observable(filteredTrackIds.contains(track.rawValue))
        } else {
            self.isOn = Observable(true)
        }
    }

    
    private func update(status: Bool) {
        if var filteredTracksDefaults = NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaultsKey.FilteredTrackIds) as? [Int] {
            if status {
                filteredTracksDefaults.append(self.id.value)
            } else {
                guard filteredTracksDefaults.contains(self.id.value) else {
                    return
                }
                filteredTracksDefaults.removeFirst(self.id.value)
            }
            NSUserDefaults.standardUserDefaults().setObject(filteredTracksDefaults, forKey: Constants.UserDefaultsKey.FilteredTrackIds)

        }
    }

}

// MARK: - TrackDetailsPresentable Conformane
extension TrackViewModel {
    var trackId: Int { return self.id.value }
    var trackName: String { return self.name.value }
}

// MARK: - TrackStatusPresentable
extension TrackViewModel {
    var isTrackOn: Bool { return self.isOn.value }
    func changeFilterPreference(status: Bool) {
        self.update(status)
    }
}

// MARK: - TrackColorPresentable 
extension TrackViewModel {
    var trackColor: UIColor {
        if let dummyEvent = Event.Track(rawValue: self.id.value) {
            return dummyEvent.getTrackColor()
        } else {
            return UIColor.whiteColor()
        }
    }
}