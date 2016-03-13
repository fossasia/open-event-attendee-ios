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
    
    lazy var visibleSessions: [SessionViewModel] = self.allSessions
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowSessionDetail") {
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                if let sessionNavigationController = segue.destinationViewController as? UINavigationController {
                    let sessionViewController = sessionNavigationController.topViewController as! SessionViewController
                    sessionViewController.sessionViewModel = visibleSessions[selectedIndexPath.row]
                }
            }
        }
    }
}

// MARK: UITableViewDataSource
extension SessionsResultsViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleSessions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SessionsBaseViewController.kSessionCellReuseIdentifier, forIndexPath: indexPath) as! SessionCell
        let sessionViewModel = visibleSessions[indexPath.row]
        cell.configure(withPresenter: sessionViewModel)
        
        return cell
    }
}