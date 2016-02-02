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
    var eventViewModel: EventViewModel?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventInfoView: EventInfoView!
    
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