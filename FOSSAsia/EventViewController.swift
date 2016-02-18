//
//  EventViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 31/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

typealias IndividualEventPresentable = protocol<EventDetailsPresentable, EventDescriptionPresentable, EventAddToCalendarPresentable>

class EventViewController: UIViewController {
    
    // Constants for Storyboard/VC
    struct StoryboardConstants {
        static let storyboardName = "IndividualEvent"
        static let viewControllerId = "EventViewController"
    }
    
    // MARK:- Properties
    var eventViewModel: EventViewModel? {
        didSet {
            eventViewModel?.favorite.observe({ (newValue) -> Void in
                self.navBarButtonItem.image = newValue ? UIImage(named: "navbar_fave_highlighted") : UIImage(named: "navbar_fave")
            })
        }
    }
    var presenter: IndividualEventPresentable?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventInfoView: EventInfoView!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var eventAddToCalendarButton: UIButton!
    @IBOutlet weak var eventAddToCalendarButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBarButtonItem: UIBarButtonItem!
    
    // MARK:- Initialization
    class func eventViewControllerForEvent(event: EventViewModel) -> EventViewController {
        let storyboard = UIStoryboard(name: EventViewController.StoryboardConstants.storyboardName, bundle: nil)
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier(EventViewController.StoryboardConstants.viewControllerId) as! EventViewController
        viewController.eventViewModel = event
        
        return viewController
    }
    
    override func viewDidLoad() {
        if let viewModel = eventViewModel {
            self.configure(viewModel)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.eventAddToCalendarButton.frame) + eventAddToCalendarButtonBottomConstraint.constant)
    }
    
    func configure(presenter: IndividualEventPresentable) {
        eventDescriptionTextView.text = presenter.eventDescription
        eventInfoView.configure(presenter)
        eventDateTimeLabel.text = "\(presenter.eventDay), \(presenter.eventDate) \(presenter.eventMonth), \(presenter.eventStartTime) - \(presenter.eventEndTime)"
        self.presenter = presenter
    }
    
    @IBAction func eventAddToCalendar(sender: UIButton) {
        let store = EKEventStore()
        
        store.requestAccessToEntityType(.Event) {(granted, error) in
            if !granted { return }
            let event = EKEvent(eventStore: store)
            event.title = (self.presenter?.eventName)!
            event.startDate = (self.presenter?.eventStartDate)!
            event.endDate = (self.presenter?.eventEndDate)!
            event.calendar = store.defaultCalendarForNewEvents
            
            let eventVC = EKEventEditViewController()
            eventVC.navigationBar.tintColor = Colors.mainRedColor
            eventVC.event = event
            eventVC.eventStore = store
            eventVC.editViewDelegate = self
            self.presentViewController(eventVC, animated: true, completion: nil)
        }
    }
    @IBAction func favoriteEvent(sender: AnyObject) {
        self.eventViewModel?.favoriteEvent({ (eventViewModel, error) -> () in
            // do something
        })
    }
}

extension EventViewController: EKEventEditViewDelegate {
    func eventEditViewController(controller: EKEventEditViewController, didCompleteWithAction action: EKEventEditViewAction) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}