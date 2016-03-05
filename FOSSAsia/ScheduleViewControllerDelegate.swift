//
//  ScheduleViewControllerDelegate.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 27/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

protocol ScheduleViewControllerDelegate: class {
    func eventDidGetSelected(tableView: UITableView, atIndexPath: NSIndexPath)
}