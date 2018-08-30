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

typealias IndividualEventPresentable = EventDetailsPresentable & EventDescriptionPresentable & EventAddToCalendarPresentable

class EventViewController: UIViewController, UINavigationControllerDelegate {

    // Constants for Storyboard/VC
    struct StoryboardConstants {
        static let storyboardName = Constants.individualEventStoryboard
        static let viewControllerId = Constants.eventViewControllerID
    }

    // MARK: - Properties
    var eventViewModel: EventViewModel? {
        didSet {
            eventViewModel?.favorite.observe({ (newValue) -> Void in
                self.navBarButtonItem.image = newValue ? UIImage(named: Constants.Images.navbarFaveHighlighted) : UIImage(named: Constants.Images.navbarFave)
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

    // MARK: - Initialization
    class func eventViewControllerForEvent(_ event: EventViewModel) -> EventViewController {
        let storyboard = UIStoryboard(name: EventViewController.StoryboardConstants.storyboardName, bundle: nil)

        let viewController = storyboard.instantiateViewController(withIdentifier: EventViewController.StoryboardConstants.viewControllerId) as! EventViewController
        viewController.eventViewModel = event

        return viewController
    }

    override func viewDidLoad() {
        if let viewModel = eventViewModel {
            self.configure(viewModel)
        }

        // navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        // navigationItem.leftItemsSupplementBackButton = true
        setBackButton()
    }

    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.eventAddToCalendarButton.frame.maxY + eventAddToCalendarButtonBottomConstraint.constant)
    }

    func configure(_ presenter: IndividualEventPresentable) {
        eventDescriptionTextView.text = presenter.eventDescription
        eventInfoView.configure(presenter)
        eventDateTimeLabel.text = "\(presenter.eventDay), \(presenter.eventDate) \(presenter.eventMonth), \(presenter.eventStartTime) - \(presenter.eventEndTime)"
        self.presenter = presenter
    }

    @IBAction func eventAddToCalendar(_ sender: UIButton) {
        let store = EKEventStore()

        store.requestAccess(to: .event) { (granted, error) in
            if !granted { return }
            let event = EKEvent(eventStore: store)
            event.title = (self.presenter?.eventName)!
            event.startDate = (self.presenter?.eventStartDate)! as Date
            event.endDate = (self.presenter?.eventEndDate)! as Date
            event.calendar = store.defaultCalendarForNewEvents

            OperationQueue.main.addOperation({ () -> Void in
                let eventVC = EKEventEditViewController()
                eventVC.navigationBar.tintColor = Colors.mainRedColor
                eventVC.event = event
                eventVC.eventStore = store
                eventVC.editViewDelegate = self
                self.present(eventVC, animated: true, completion: nil)
            })
        }
    }
    @IBAction func favoriteEvent(_ sender: AnyObject) {
        self.eventViewModel?.favoriteEvent { [weak self] (eventViewModel, error) -> Void in
            if let masterNavVC = self?.splitViewController?.viewControllers[0] as? UINavigationController {
                if let masterVC = masterNavVC.topViewController as? EventsBaseListViewController {
                    OperationQueue.main.addOperation({ () -> Void in
                        masterVC.currentViewController.tableView.reloadData()
                    })
                }
            }
        }
    }
}



extension EventViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        self.dismiss(animated: true, completion: nil)
    }

    func setBackButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(AuthTabBarViewController.backAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        button.imageEdgeInsets = UIEdgeInsetsMake(1, -32, 1, 32)
        let label = UILabel(frame: CGRect(x: 3, y: 5, width: 50, height: 20))
        label.text = "Back"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }


    @objc func backAction() {

        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else {
            fatalError("Cannot Cast to UITabBarController")
        }
        vc.selectedIndex = 0
        self.present(vc, animated: true, completion: nil)

    }
}
