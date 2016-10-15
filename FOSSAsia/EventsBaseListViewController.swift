//
//  EventsBaseListViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 12/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import Pages

class EventsBaseListViewController: UIViewController, EventListBrowsingByDate, UIViewControllerPreviewingDelegate  {
    fileprivate var collapseDetailViewController = true
    weak var pagesVC: PagesController!
    @IBOutlet weak var pagingView: SchedulePagingView!
 
    var currentViewController: EventsBaseViewController! {
        didSet {
            self.registerForPreviewing(with: self, sourceView: currentViewController.tableView)
            currentViewController.delegate = self
        }
    }
    var viewModel: EventsListViewModel? {
        didSet {
            viewModel?.allSchedules.observe {
                [unowned self] in
                guard $0.count > 0 else {
                    return
                }
                self.onViewModelScheduleChange($0)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = getEventsListViewModel()
        pagingView.delegate = self
        navigationController?.splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EventsPageViewController") {
            if let embeddedPageVC = segue.destination as? PagesController {
                self.pagesVC = embeddedPageVC
                let storyboard = UIStoryboard(name: LoadingViewController.StoryboardConstants.storyboardName, bundle: nil)
                let loadingVC = storyboard.instantiateViewController(withIdentifier: LoadingViewController.StoryboardConstants.viewControllerId)
                self.pagesVC.add([loadingVC])
                self.pagesVC.enableSwipe = false
                self.pagesVC.pagesDelegate = self
            }
        }
    }
    
    func onViewModelScheduleChange(_ newSchedule: [ScheduleViewModel]) {
        let viewControllers = newSchedule.map { viewModel in
            return ScheduleViewController.scheduleViewControllerFor(viewModel)
        }
        self.pagesVC.add(viewControllers)
        self.pagesVC.startPage = 1
    }
}

// MARK:- ScheduleViewControllerDelegate Conformance {
extension EventsBaseListViewController: ScheduleViewControllerDelegate {
    func eventDidGetSelected(_ tableView: UITableView, atIndexPath: IndexPath) {
        collapseDetailViewController = false
    }
}

// MARK:- UISplitViewControllerDelegate Conformance
extension EventsBaseListViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
}

// MARK:- UIViewControllerPreviewingDelegate Conformance
extension EventsBaseListViewController {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.currentViewController.tableView.indexPathForRow(at: location) else {
            return nil
        }
        
        let eventVM = self.currentViewController.eventViewModelForIndexPath(indexPath)
        if let eventCell = self.currentViewController.tableView.cellForRow(at: indexPath) {
            previewingContext.sourceRect = eventCell.frame
        }
        
        let eventVC = EventViewController.eventViewControllerForEvent(eventVM)
        return eventVC
    }
    
    @objc(previewingContext:commitViewController:) func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

extension EventsBaseListViewController {
    func nextButtonDidPress(_ sender: SchedulePagingView) {
        self.pagesVC.next()
        
    }
    func prevButtonDidPress(_ sender: SchedulePagingView) {
        self.pagesVC.previous()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, setViewController viewController: UIViewController, atPage page: Int) {
        guard let currentVC = viewController as? EventsBaseViewController else {
            return
        }
        pagingView.dateLabel.text = ((currentVC.viewModel?.date.value)! as NSDate).formattedDate(withFormat: "EEEE, MMM dd")
        
        // Govern Previous Button
        if page == 1 {
            pagingView.prevButton.isEnabled = false
        } else {
            pagingView.prevButton.isEnabled = true
        }
        
        // Govern Next Button
        if let scheduleViewModels = viewModel {
            if page == scheduleViewModels.count.value {
                pagingView.nextButton.isEnabled = false
            } else {
                pagingView.nextButton.isEnabled = true
            }
        }
        
        self.currentViewController = currentVC
        
    }
}
