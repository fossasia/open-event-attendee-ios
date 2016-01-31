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
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventInfoView: EventInfoView!
    
    override func viewDidLoad() {
        if let viewModel = eventViewModel {
            self.configure(viewModel)
        }
    }
    
    func configure(presenter: IndividualEventPresentable) {
        eventDescriptionTextView.text = presenter.eventDescription
        eventInfoView.configure(presenter)
    }
}
