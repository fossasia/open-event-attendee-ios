//
//  EventsBaseViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 7/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

class EventsBaseViewController: UIViewController {
    weak var delegate: ScheduleViewControllerDelegate?
    static let kEventCellReuseIdentifier = "EventCell"
    var allEvents: [EventViewModel] = []

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ScheduleViewModel? {
        didSet {
            viewModel?.events.observe {
                [unowned self] in
                self.allEvents = $0
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.refresh()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowEventDetail") {
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                if let eventNavigationController = segue.destinationViewController as? UINavigationController {
                    let eventViewController = eventNavigationController.topViewController as! EventViewController
                    eventViewController.eventViewModel = allEvents[selectedIndexPath.row]
                }
            }
        }
    }
    
    func eventViewModelForIndexPath(path: NSIndexPath) -> EventViewModel {
        return allEvents[path.row]
    }
    
}

extension EventsBaseViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.eventDidGetSelected(tableView, atIndexPath: indexPath)
    }
}

extension EventsBaseViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EventsBaseViewController.kEventCellReuseIdentifier, forIndexPath: indexPath) as! EventCell
        let eventViewModel = allEvents[indexPath.row]
        cell.configure(withPresenter: eventViewModel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents.count
    }
}
