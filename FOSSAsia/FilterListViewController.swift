//
//  FilterListViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 4/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

class FilterListViewController: UIViewController {
    private let kFilterCellReuseIdentifier = "FilterCell"
    @IBOutlet weak var filterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = Colors.mainRedColor
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func trackSwitchFlipped(switchState: AnyObject) {
        
    }
}

extension FilterListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfTracks
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Tracks"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.filterTableView.dequeueReusableCellWithIdentifier(kFilterCellReuseIdentifier, forIndexPath: indexPath) as! FilterCell
        let trackId = indexPath.row + 1
        let trackViewModel = TrackViewModel(Event.Track(rawValue: trackId)!)
        
        cell.configure(trackViewModel)
        

        return cell
    }
}
