//
//  SessionsSearchViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 7/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

class EventsResultsViewController: EventsBaseViewController {
    
    struct StoryboardConstants {
        static let storyboardName = "ScheduleVC"
        static let viewControllerId = String(describing: EventsResultsViewController.self)
    }
    
    lazy var visibleEvents: [EventViewModel] = self.allEvents
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowEventDetail") {
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                if let eventNavigationController = segue.destination as? UINavigationController {
                    let eventViewController = eventNavigationController.topViewController as! EventViewController
                    eventViewController.eventViewModel = visibleEvents[(selectedIndexPath as NSIndexPath).row]
                }
            }
        }
    }
}

// MARK: UITableViewDataSource
extension EventsResultsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsBaseViewController.kEventCellReuseIdentifier, for: indexPath) as! EventCell
        let eventViewModel = visibleEvents[(indexPath as NSIndexPath).row]
        cell.configure(withPresenter: eventViewModel)
        
        return cell
    }
}
