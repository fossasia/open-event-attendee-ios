//
//  FavoriteSessionsListViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 12/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import Pages

class FavoriteSessionsListViewController: SessionsBaseListViewController {
    override func viewDidLoad() {
        viewModel = getSessionsListViewModel()
        super.viewDidLoad()
        if let currentVC = currentViewController {
            self.registerForPreviewingWithDelegate(self, sourceView: currentVC.tableView)
        }
    }
    
    override func onViewModelScheduleChange(newSchedule: [ScheduleViewModel]) {
        let viewControllers = newSchedule.map { viewModel in
            return FavoritesScheduleViewController.scheduleViewControllerFor(viewModel)
        }
        self.pagesVC.add(viewControllers)
        self.pagesVC.startPage = 1
    }
    
}