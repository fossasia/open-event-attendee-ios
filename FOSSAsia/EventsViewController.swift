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
    private var eventsArray: [Event] = []

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        self.shyNavBarManager.scrollView = tableView;
        
        let event1 = Event(trackCode: .General, title:"Snacks", shortDescription: "Just saying hi", speaker: nil, location: "Biopolis Matrix", startDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 00, second: 00), endDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 30, second: 00))
        let event2 = Event(trackCode: .Mozilla, title: "Collaborative Webmaking using TogetherJS", shortDescription: "", speaker: nil, location: "JFDI Blk 71", startDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 00, second: 00), endDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 30, second: 00))
        let event3 = Event(trackCode: .DevOps, title: "oVirt Workshop", shortDescription: "", speaker: nil, location: "JFDI Blk 71", startDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 00, second: 00), endDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 30, second: 00))
        let event4 = Event(trackCode: .OpenTech, title: "Free/Libre Open Source Software Licenses", shortDescription: "", speaker: nil, location: "NUS Plug-In Blk 71", startDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 30, second: 00), endDateTime: NSDate(year: 2015, month: 03, day: 14, hour: 09, minute: 50, second: 00))

        
        eventsArray.append(event1)
        eventsArray.append(event2)
        eventsArray.append(event3)
        eventsArray.append(event4)
        
        filterButton.addTarget(self, action: "handleFilterButtonPressed:", forControlEvents: .TouchUpInside)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowEventDetail") {
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                let eventViewController = segue.destinationViewController as! EventViewController
                eventViewController.eventViewModel = EventViewModel(eventsArray[selectedIndexPath.row])
            }
        }
    }

}

extension EventsViewController: UITableViewDelegate {
    
}

extension EventsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kEventCellReuseIdentifier, forIndexPath: indexPath) as! EventCell
        let viewModel = EventViewModel(eventsArray[indexPath.row])
        cell.configure(withPresenter: viewModel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}