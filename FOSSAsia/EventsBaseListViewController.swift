//
//  EventsBaseListViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 12/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import Pages

class EventsBaseListViewController: UIViewController, EventListBrowsingByDate  {
    weak var pagesVC: PagesController!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = getEventsListViewModel()
        pagingView.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "EventsPageViewController") {
            if let embeddedPageVC = segue.destinationViewController as? PagesController {
                self.pagesVC = embeddedPageVC
                let storyboard = UIStoryboard(name: LoadingViewController.StoryboardConstants.storyboardName, bundle: nil)
                let loadingVC = storyboard.instantiateViewControllerWithIdentifier(LoadingViewController.StoryboardConstants.viewControllerId)
                self.pagesVC.add([loadingVC])
                self.pagesVC.enableSwipe = false
                self.pagesVC.pagesDelegate = self
            }
        }
    }
}

extension EventsBaseListViewController {
    func nextButtonDidPress(sender: SchedulePagingView) {
        self.pagesVC.next()
        
    }
    func prevButtonDidPress(sender: SchedulePagingView) {
        self.pagesVC.previous()
    }
    
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
    }
}