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
    private let tempEventsArray = ["Opening", "Welcome", "Open Technologies in Singapore", "Novena and Open Hardware Development"]

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        self.shyNavBarManager.scrollView = tableView;
        
        let event1 = Event(trackCode: .General, title:"Opening", shortDescription: "Just saying hi", speaker: nil, location: "Biopolis Matrix", dateTime: NSDate(year: 2015, month: 03, day: 13, hour: 09, minute: 00, second: 00))
        eventsArray.append(event1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension EventsViewController: UITableViewDelegate {
    
}

extension EventsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EventCell
        let cell = tableView.dequeueReusableCellWithIdentifier(kEventCellReuseIdentifier, forIndexPath: indexPath) as! EventCell
        
        let viewModel = EventViewModel(eventsArray[indexPath.row])
        cell.configure(withPresenter: viewModel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
}