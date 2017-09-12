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
        resultsTableController = storyboard.instantiateViewController(withIdentifier: EventsResultsViewController.StoryboardConstants.viewControllerId) as! EventsResultsViewController

        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
        // calling .view will force Storyboards to render the view hierarchy to make tableView accessible
        let _ = searchController.view
        resultsTableController.tableView.delegate = self
        
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = Colors.creamTintColor
        searchController.searchBar.placeholder = "Search"
        if let textFieldInSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInSearchBar.textColor = Colors.creamTintColor
        }
        
        navigationItem.titleView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EventsPageViewController") {
            if let embeddedPageVC = segue.destination as? PagesController {
                self.pagesVC = embeddedPageVC
                let loadingVC = self.storyboard!.instantiateViewController(withIdentifier: LoadingViewController.StoryboardConstants.viewControllerId)
                self.pagesVC.add([loadingVC])
                self.pagesVC.enableSwipe = false
                self.pagesVC.pagesDelegate = self
            }
        }
    }
    
    fileprivate func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}

extension EventsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else {
            return
        }
        filterString = searchController.searchBar.text
    }
}

extension EventsListViewController: UITableViewDelegate {
    // This delegate is for the UISearchController.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEventViewModel: EventViewModel
        
        selectedEventViewModel = resultsTableController.visibleEvents[(indexPath as NSIndexPath).row]
        
        let storyboard = UIStoryboard(name: EventViewController.StoryboardConstants.storyboardName, bundle: nil)
        if let nvc = storyboard.instantiateViewController(withIdentifier: "IndividualEventNavController") as? UINavigationController {
            if let eventVC = nvc.topViewController as? EventViewController {
                eventVC.eventViewModel = selectedEventViewModel
                splitViewController?.showDetailViewController(nvc, sender: self)
                searchController.searchBar.resignFirstResponder()
            }
        }
    }
    
}
