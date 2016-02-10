//
//  EventsListViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 10/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

class EventsListViewController: UIViewController {
    weak var pageVC: UIPageViewController!
    private (set) var scheduleViewControllers: [ScheduleViewController]!
    var viewModel: EventsListViewModel? {
        didSet {
            viewModel?.allSchedules.observe { viewModels in
                let viewControllers = viewModels.map { viewModel in
                    return ScheduleViewController.scheduleViewControllerFor(viewModel)
                }
                self.scheduleViewControllers = viewControllers
                if let firstVC = self.scheduleViewControllers.first {
                    self.pageVC.setViewControllers([firstVC], direction: .Forward, animated: true, completion: { (done) -> Void in
                        if done {
                            self.currentViewController = firstVC
                        }
                    })
                }
            }
        }
    }
    
    var currentViewController: ScheduleViewController!
    var searchController: UISearchController!
    var resultsTableController: EventsResultsViewController!
    var filterString: String? = nil {
        didSet {
            currentViewController.filterString = filterString
            resultsTableController.visibleEvents = currentViewController.filteredEvents
            resultsTableController.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = EventsListViewModel()
        
        resultsTableController = storyboard!.instantiateViewControllerWithIdentifier(EventsResultsViewController.StoryboardConstants.viewControllerId) as! EventsResultsViewController
        resultsTableController.allEvents = currentViewController.allEvents
        
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
            if let embeddedPageVC = segue.destinationViewController as? UIPageViewController {
                self.pageVC = embeddedPageVC
                self.pageVC.dataSource = self
            }
        }
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedEventViewModel: EventViewModel

        selectedEventViewModel = resultsTableController.visibleEvents[indexPath.row]
        
        let eventViewController = EventViewController.eventViewControllerForEvent(selectedEventViewModel)
        
        navigationController?.pushViewController(eventViewController, animated: true)
    }
    
}

extension EventsListViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let scheduleViewController = viewController as? ScheduleViewController else {
            return nil
        }
        
        guard let viewControllerIndex = scheduleViewControllers.indexOf(scheduleViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 &&
            scheduleViewControllers.count > previousIndex else {
            return nil
        }
        self.currentViewController = scheduleViewControllers[previousIndex]
        return scheduleViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let scheduleViewController = viewController as? ScheduleViewController else {
            return nil
        }
        
        guard let viewControllerIndex = scheduleViewControllers.indexOf(scheduleViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let viewControllersCount = scheduleViewControllers.count
        guard viewControllersCount != nextIndex &&
            viewControllersCount > nextIndex else {
                return nil
        }
        self.currentViewController = scheduleViewControllers[nextIndex]
        return scheduleViewControllers[nextIndex]

    }
}