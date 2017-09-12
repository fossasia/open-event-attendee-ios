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
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowEventDetail") {
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                if let eventNavigationController = segue.destination as? UINavigationController {
                    let eventViewController = eventNavigationController.topViewController as! EventViewController
                    eventViewController.eventViewModel = allEvents[(selectedIndexPath as NSIndexPath).row]
                }
            }
        }
    }
    
    func eventViewModelForIndexPath(_ path: IndexPath) -> EventViewModel {
        return allEvents[(path as NSIndexPath).row]
    }
    
}

extension EventsBaseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.eventDidGetSelected(tableView, atIndexPath: indexPath)
    }
}

extension EventsBaseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsBaseViewController.kEventCellReuseIdentifier, for: indexPath) as! EventCell
        let eventViewModel = allEvents[(indexPath as NSIndexPath).row]
        cell.configure(withPresenter: eventViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents.count
    }
    

}
