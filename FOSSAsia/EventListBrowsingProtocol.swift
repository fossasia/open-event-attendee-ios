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
    func getEventsListViewModel() -> SessionsListViewModel
}

extension EventsPresentable where Self: EventsBaseListViewController {
    func getEventsListViewModel() -> SessionsListViewModel {
        return SessionsListViewModel()
    }
}

extension EventsPresentable where Self: FavoriteEventsListViewController {
    func getEventsListViewModel() -> SessionsListViewModel {
        var eventsViewModel = SessionsListViewModel()
        eventsViewModel.setFavoritesOnly(true)
        return eventsViewModel
    }
}

protocol SchedulePagingViewDelegate: class {
    func nextButtonDidPress(sender: SchedulePagingView)
    func prevButtonDidPress(sender: SchedulePagingView)
}
