//
//  SessionsResultsViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 7/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

class SessionsResultsViewController: SessionsBaseViewController {
    
    struct StoryboardConstants {
        static let storyboardName = "ScheduleVC"
        static let viewControllerId = String(SessionsResultsViewController)
    }
    
    lazy var visibleEvents: [SessionViewModel] = self.allEvents
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowEventDetail") {
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                if let eventNavigationController = segue.destinationViewController as? UINavigationController {
                    let sessionViewController = eventNavigationController.topViewController as! SessionViewController
                    sessionViewController.sessionViewModel = visibleEvents[selectedIndexPath.row]
                }
            }
        }
    }
}

// MARK: UITableViewDataSource
extension SessionsResultsViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleEvents.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SessionsBaseViewController.kSessionCellReuseIdentifier, forIndexPath: indexPath) as! SessionCell
        let eventViewModel = visibleEvents[indexPath.row]
        cell.configure(withPresenter: eventViewModel)
        
        return cell
    }
}