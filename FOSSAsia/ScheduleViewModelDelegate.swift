//
//  ScheduleViewModelDelegate.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 5/3/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

protocol ScheduleViewModelDelegate: class {
    func scheduleDidLoad(schedule: Schedule?, error: Error?)
}

extension ScheduleViewController {
    func scheduleDidLoad(schedule: Schedule?, error: Error?) {
        guard error == nil else {
            let alert = UIAlertController(title: "Error", message: "Could not load stock quotes \(error.debugDescription)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let now = NSDate()
        let updateString = "Last updated: " + now.formattedDateWithFormat("dd MMMM yyyy, HH:mm:ss", locale: NSLocale.autoupdatingCurrentLocale())
        self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
        if self.refreshControl.refreshing {
            NSOperationQueue.mainQueue().addOperationWithBlock({ [unowned self] () -> Void in
                self.refreshControl.endRefreshing()
            })
        }
    }
}