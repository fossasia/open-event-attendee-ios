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
    private let tempEventsArray = ["Opening", "Welcome", "Open Technologies in Singapore", "Novena and Open Hardware Development"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kEventCellReuseIdentifier)
        self.shyNavBarManager.scrollView = tableView;
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
        let eventName = tempEventsArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(kEventCellReuseIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = eventName
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempEventsArray.count
    }
}