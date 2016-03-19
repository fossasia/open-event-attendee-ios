//
//  SessionListBrowsingProtocol.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 12/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation
import Pages

typealias SessionListBrowsingByDate = protocol<SessionsPresentable, SchedulePagingViewDelegate, PagesControllerDelegate>

protocol SessionsPresentable {
    func getSessionsListViewModel() -> SessionsListViewModel
}

extension SessionsPresentable where Self: SessionsBaseListViewController {
    func getSessionsListViewModel() -> SessionsListViewModel {
        return SessionsListViewModel()
    }
}

extension SessionsPresentable where Self: FavoriteSessionsListViewController {
    func getSessionsListViewModel() -> SessionsListViewModel {
        var sessionsViewModel = SessionsListViewModel()
        sessionsViewModel.setFavoritesOnly(true)
        return sessionsViewModel
    }
}

protocol SchedulePagingViewDelegate: class {
    func nextButtonDidPress(sender: SchedulePagingView)
    func prevButtonDidPress(sender: SchedulePagingView)
}
