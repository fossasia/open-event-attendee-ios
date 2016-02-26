//
//  EventsListViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 10/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import Pages

class EventsListViewController: EventsBaseListViewController {
    var searchController: UISearchController!
    var resultsTableController: EventsResultsViewController!
    
    var filterString: String? = nil {
        didSet {
            guard let scheduleVC = currentViewController as? ScheduleViewController else {
                return
            }
            
            scheduleVC.filterString = filterString
            resultsTableController.visibleEvents = scheduleVC.filteredEvents
            resultsTableController.tableView.reloadData()

        }
    }
    override var currentViewController: EventsBaseViewController! {
        didSet {
            if resultsTableController != nil {
                resultsTableController.allEvents = currentViewController.allEvents
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = self.getEventsListViewModel()
        pagingView.delegate = self
        
        let storyboard = UIStoryboard(name: EventsResultsViewController.StoryboardConstants.storyboardName, bundle: nil)
        resultsTableController = storyboard.instantiateViewControllerWithIdentifier(EventsResultsViewController.StoryboardConstants.viewControllerId) as! EventsResultsViewController

        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
        // calling .view will force Storyboards to render the view hierarchy to make tableView accessible
        let _ = searchController.view
        resultsTableController.tableView.delegate = self
        
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.tintColor = Colors.creamTintColor
        searchController.searchBar.placeholder = "Search"
        if let textFieldInSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField {
            textFieldInSearchBar.textColor = Colors.creamTintColor
        }
        
        navigationItem.titleView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EventsPageViewController") {
            if let embeddedPageVC = segue.destinationViewController as? PagesController {
                self.pagesVC = embeddedPageVC
                let loadingVC = self.storyboard!.instantiateViewControllerWithIdentifier(LoadingViewController.StoryboardConstants.viewControllerId)
                self.pagesVC.add([loadingVC])
                self.pagesVC.enableSwipe = false
                self.pagesVC.pagesDelegate = self
            }
        }
    }
    
    private func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

extension EventsListViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard searchController.active else {
            return
        }
        filterString = searchController.searchBar.text
    }
}

extension EventsListViewController: UITableViewDelegate {
    // This delegate is for the UISearchController.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedEventViewModel: EventViewModel
        
        selectedEventViewModel = resultsTableController.visibleEvents[indexPath.row]
        
        let eventViewController = EventViewController.eventViewControllerForEvent(selectedEventViewModel)
        
        navigationController?.pushViewController(eventViewController, animated: true)
    }
    
}
