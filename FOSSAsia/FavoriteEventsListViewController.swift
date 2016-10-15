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
        super.viewDidLoad()
        if let currentVC = currentViewController {
            self.registerForPreviewing(with: self, sourceView: currentVC.tableView)
        }
    }
    
    override func onViewModelScheduleChange(_ newSchedule: [ScheduleViewModel]) {
        let viewControllers = newSchedule.map { viewModel in
            return FavoritesScheduleViewController.scheduleViewControllerFor(viewModel)
        }
        self.pagesVC.add(viewControllers)
        self.pagesVC.startPage = 1
    }
    
}
