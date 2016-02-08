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
        static let storyboardName = "Sessions"
        static let viewControllerId = "EventsResultsViewController"
    }
    
    lazy var visibleEvents: [EventViewModel] = self.allEvents
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: UITableViewDataSource
extension EventsResultsViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleEvents.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kEventCellReuseIdentifier, forIndexPath: indexPath) as! EventCell
        let eventViewModel = visibleEvents[indexPath.row]
        cell.configure(withPresenter: eventViewModel)
        
        return cell
    }
}