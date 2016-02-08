//
//  EventViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 31/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

typealias IndividualEventPresentable = protocol<EventDetailsPresentable, EventDescriptionPresentable>

class EventViewController: UIViewController {
    
    // Constants for Storyboard/VC
    struct StoryboardConstants {
        static let storyboardName = "Sessions"
        static let viewControllerId = "EventViewController"
    }
    
    // MARK:- Properties
    var eventViewModel: EventViewModel?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventInfoView: EventInfoView!
    
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
        self.eventDescriptionTextView.frame.size = self.eventDescriptionTextView.sizeThatFits(CGSizeMake(self.eventDescriptionTextView.frame.size.width, CGFloat.max))
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(self.eventDescriptionTextView.frame))
    }
    
    func configure(presenter: IndividualEventPresentable) {
        eventDescriptionTextView.text = presenter.eventDescription
        eventInfoView.configure(presenter)
    }
}