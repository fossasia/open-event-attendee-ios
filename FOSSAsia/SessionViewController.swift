//
//  SessionViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 31/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

typealias IndividualSessionPresentable = protocol<SessionDetailsPresentable, SessionDescriptionPresentable, SessionAddToCalendarPresentable>

class SessionViewController: UIViewController {
    
    // Constants for Storyboard/VC
    struct StoryboardConstants {
        static let storyboardName = "IndividualSession"
        static let viewControllerId = "SessionViewController"
    }
    
    // MARK:- Properties
    var sessionViewModel: SessionViewModel? {
        didSet {
            sessionViewModel?.favorite.observe({ (newValue) -> Void in
                self.navBarButtonItem.image = newValue ? UIImage(named: "navbar_fave_highlighted") : UIImage(named: "navbar_fave")
            })
        }
    }
    var presenter: IndividualSessionPresentable?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sessionDescriptionTextView: UITextView!
    @IBOutlet weak var sessionInfoView: SessionInfoView!
    @IBOutlet weak var sessionDateTimeLabel: UILabel!
    @IBOutlet weak var sessionAddToCalendarButton: UIButton!
    @IBOutlet weak var sessionAddToCalendarButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBarButtonItem: UIBarButtonItem!
    
    // MARK:- Initialization
    class func sessionViewControllerForSession(session: SessionViewModel) -> SessionViewController {
        let storyboard = UIStoryboard(name: SessionViewController.StoryboardConstants.storyboardName, bundle: nil)
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier(SessionViewController.StoryboardConstants.viewControllerId) as! SessionViewController
        viewController.sessionViewModel = session
        
        return viewController
    }
    
    override func viewDidLoad() {
        if let viewModel = sessionViewModel {
            self.configure(viewModel)
        }
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.sessionAddToCalendarButton.frame) + sessionAddToCalendarButtonBottomConstraint.constant)
    }
    
    func configure(presenter: IndividualSessionPresentable) {
        sessionDescriptionTextView.text = presenter.sessionDescription
        sessionInfoView.configure(presenter)
        sessionDateTimeLabel.text = "\(presenter.sessionDay), \(presenter.sessionDate) \(presenter.sessionMonth), \(presenter.sessionStartTime) - \(presenter.sessionEndTime)"
        self.presenter = presenter
    }
    
    @IBAction func sessionAddToCalendar(sender: UIButton) {
        let store = EKEventStore()
        
        store.requestAccessToEntityType(.Event) {(granted, error) in
            if !granted { return }
            let session = EKEvent(eventStore: store)
            session.title = (self.presenter?.sessionName)!
            session.startDate = (self.presenter?.sessionStartDate)!
            session.endDate = (self.presenter?.sessionEndDate)!
            session.calendar = store.defaultCalendarForNewEvents
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let sessionVC = EKEventEditViewController()
                sessionVC.navigationBar.tintColor = Colors.mainRedColor
                sessionVC.event = session
                sessionVC.eventStore = store
                sessionVC.editViewDelegate = self
                self.presentViewController(sessionVC, animated: true, completion: nil)
            })
        }
    }
    @IBAction func favoriteSession(sender: AnyObject) {
        self.sessionViewModel?.favoriteSession{  [weak self] (sessionViewModel, error) -> () in
            if let masterNavVC = self?.splitViewController?.viewControllers[0] as? UINavigationController {
                if let masterVC = masterNavVC.topViewController as? SessionsBaseListViewController {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        masterVC.currentViewController.tableView.reloadData()
                    })
                }
            }
        }
    }
}

extension SessionViewController: EKEventEditViewDelegate {
    func eventEditViewController(controller: EKEventEditViewController, didCompleteWithAction action: EKEventEditViewAction) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}