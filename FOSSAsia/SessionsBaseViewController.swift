//
//  SessionsBaseViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 7/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

class SessionsBaseViewController: UIViewController {
    weak var delegate: ScheduleViewControllerDelegate?
    static let kSessionCellReuseIdentifier = "SessionCell"
    var allSessions: [SessionViewModel] = []

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ScheduleViewModel? {
        didSet {
            viewModel?.sessions.observe {
                [unowned self] in
                self.allSessions = $0
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
        if (segue.identifier == "ShowSessionDetail") {
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                if let sessionNavigationController = segue.destinationViewController as? UINavigationController {
                    let sessionViewController = sessionNavigationController.topViewController as! SessionViewController
                    sessionViewController.sessionViewModel = allSessions[selectedIndexPath.row]
                }
            }
        }
    }
    
    func sessionViewModelForIndexPath(path: NSIndexPath) -> SessionViewModel {
        return allSessions[path.row]
    }
    
}

extension SessionsBaseViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.sessionDidGetSelected(tableView, atIndexPath: indexPath)
    }
}

extension SessionsBaseViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SessionsBaseViewController.kSessionCellReuseIdentifier, forIndexPath: indexPath) as! SessionCell
        let sessionViewModel = allSessions[indexPath.row]
        cell.configure(withPresenter: sessionViewModel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSessions.count
    }
}
