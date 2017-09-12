//
//  ScheduleViewModelDelegate.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 5/3/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

protocol ScheduleViewModelDelegate: class {
    func scheduleDidLoad(_ schedule: Schedule?, error: Error?)
}

extension ScheduleViewController {
    func scheduleDidLoad(_ schedule: Schedule?, error: Error?) {
        guard error == nil else {
            let alert = UIAlertController(title: "Error", message: "Could not load stock quotes \(error.debugDescription)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let now = Date()
        let updateString = "Last updated: " + (now as NSDate).formattedDate(withFormat: "dd MMMM yyyy, HH:mm:ss", locale: Locale.autoupdatingCurrent)
        self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
        if self.refreshControl.isRefreshing {
            OperationQueue.main.addOperation({ [unowned self] () -> Void in
                self.refreshControl.endRefreshing()
            })
        }
    }
}
