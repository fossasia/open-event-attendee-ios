//
//  EventListBrowsingProtocol.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 12/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation
import Pages

typealias EventListBrowsingByDate = protocol<EventsPresentable, SchedulePagingViewDelegate, PagesControllerDelegate>

protocol EventsPresentable {
    func getEventsListViewModel() -> EventsListViewModel
}

extension EventsPresentable where Self: EventsBaseListViewController {
    func getEventsListViewModel() -> EventsListViewModel {
        return EventsListViewModel()
    }
}

extension EventsPresentable where Self: FavoriteEventsListViewController {
    func getEventsListViewModel() -> EventsListViewModel {
        var eventsViewModel = EventsListViewModel()
        eventsViewModel.setFavoritesOnly(true)
        return eventsViewModel
    }
}

protocol SchedulePagingViewDelegate: class {
    func nextButtonDidPress(sender: SchedulePagingView)
    func prevButtonDidPress(sender: SchedulePagingView)
}
