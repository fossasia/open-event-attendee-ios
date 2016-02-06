//
//  FirstViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {
    private let kEventCellReuseIdentifier = "EventCell"
    private var eventsArray: [EventViewModel] = []

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ScheduleViewModel? {
        didSet {
            viewModel?.events.observe {
                [unowned self] in
                self.eventsArray = $0
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        self.shyNavBarManager.scrollView = tableView
        self.shyNavBarManager.stickyExtensionView = true
        
        viewModel = ScheduleViewModel(NSDate(year: 2015, month: 03, day: 14))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowEventDetail") {
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                let eventViewController = segue.destinationViewController as! EventViewController
                eventViewController.eventViewModel = eventsArray[selectedIndexPath.row]
            }
        }
    }

}

extension EventsViewController: UITableViewDelegate {
    
}

extension EventsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kEventCellReuseIdentifier, forIndexPath: indexPath) as! EventCell
        let viewModel = eventsArray[indexPath.row]
        cell.configure(withPresenter: viewModel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // have to patch in code because IB wasn't listening to me
        return 70
    }
}