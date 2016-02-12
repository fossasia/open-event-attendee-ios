//
//  FavoriteEventsListViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 12/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import Pages

class FavoriteEventsListViewController: EventsBaseListViewController {    
    override func viewDidLoad() {
        viewModel = getEventsListViewModel()
        pagingView.delegate = self
    }
}

extension FavoriteEventsListViewController {
    func getEventsListViewModel() -> EventsListViewModel {
        var eventsViewModel = EventsListViewModel()
        eventsViewModel.setFavoritesOnly(true)
        return eventsViewModel
    }
}
