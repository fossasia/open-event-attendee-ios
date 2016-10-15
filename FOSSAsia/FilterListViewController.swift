//
//  FilterListViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 4/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

class FilterListViewController: UIViewController {
    fileprivate let kFilterCellReuseIdentifier = "FilterCell"
    @IBOutlet weak var filterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = Colors.mainRedColor
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension FilterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfTracks
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Tracks"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.filterTableView.dequeueReusableCell(withIdentifier: kFilterCellReuseIdentifier, for: indexPath) as! FilterCell
        let trackId = (indexPath as NSIndexPath).row + 1
        let trackViewModel = TrackViewModel(Event.Track(rawValue: trackId)!)
        
        cell.configure(trackViewModel)
        

        return cell
    }
}
