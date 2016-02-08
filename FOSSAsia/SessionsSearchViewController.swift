//
//  SessionsSearchViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 7/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

class SessionsSearchViewController: EventsBaseViewController, UISearchResultsUpdating {
    struct StoryboardConstants {
        static let identifier = "SessionsSearchViewController"
    }
    
    lazy var visibleEvents: [EventViewModel] = self.allEvents
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var filterString: String? = nil {
        didSet {
            if filterString == nil || filterString!.isEmpty {
                visibleEvents = self.allEvents
            } else {
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!])
                visibleEvents = allEvents.filter( {filterPredicate.evaluateWithObject($0.eventName) } )
            }
            tableView.reloadData()
        }
        
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard searchController.active else { return }
    
        filterString = searchController.searchBar.text
    }
}

// MARK: UITableViewDataSource
extension SessionsSearchViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleEvents.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kEventCellReuseIdentifier, forIndexPath: indexPath) as! EventCell
        let eventViewModel = visibleEvents[indexPath.row]
        cell.configure(withPresenter: eventViewModel)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}