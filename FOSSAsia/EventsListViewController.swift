//
//  EventsListViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 10/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import Pages

class EventsListViewController: UIViewController {
    weak var pagesVC: PagesController!
    var searchController: UISearchController!
    var resultsTableController: EventsResultsViewController!
    @IBOutlet weak var pagingView: SchedulePagingView!
    
    
    var viewModel: EventsListViewModel? {
        didSet {
            viewModel?.allSchedules.observe {
                [unowned self] in
                guard $0.count > 0 else {
                    return
                }
                let viewControllers = $0.map { viewModel in
                    return ScheduleViewController.scheduleViewControllerFor(viewModel)
                }
                self.pagesVC.add(viewControllers)
                self.pagesVC.startPage = 1
            }
        }
    }
    
    var filterString: String? = nil {
        didSet {
            currentViewController.filterString = filterString
            resultsTableController.visibleEvents = currentViewController.filteredEvents
            resultsTableController.tableView.reloadData()
        }
    }
    var currentViewController: ScheduleViewController! {
        didSet {
            if resultsTableController != nil {
                resultsTableController.allEvents = currentViewController.allEvents
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EventsListViewModel()
        pagingView.delegate = self
        
        resultsTableController = storyboard!.instantiateViewControllerWithIdentifier(EventsResultsViewController.StoryboardConstants.viewControllerId) as! EventsResultsViewController

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
                let loadingVC = self.storyboard!.instantiateViewControllerWithIdentifier("LoadingVC")
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

extension EventsListViewController: SchedulePagingViewDelegate {
    func nextButtonDidPress(sender: SchedulePagingView) {
        self.pagesVC.next()

    }
    func prevButtonDidPress(sender: SchedulePagingView) {
        self.pagesVC.previous()
    }
}

extension EventsListViewController: PagesControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, setViewController viewController: UIViewController, atPage page: Int) {
        guard let currentVC = viewController as? ScheduleViewController else {
            return
        }
        pagingView.dateLabel.text = currentVC.viewModel?.date.value.formattedDateWithFormat("EEEE, MMM dd")
        
        // Govern Previous Button
        if page == 1 {
            pagingView.prevButton.enabled = false
        } else {
            pagingView.prevButton.enabled = true
        }
        
        // Govern Next Button
        if let scheduleViewModels = viewModel {
            if page == scheduleViewModels.count.value {
                pagingView.nextButton.enabled = false
            } else {
                pagingView.nextButton.enabled = true
            }
        }
        
        self.currentViewController = currentVC
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