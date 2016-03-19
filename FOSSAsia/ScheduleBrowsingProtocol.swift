//
//  ScheduleBrowsingProtocol.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 13/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation
import MGSwipeTableCell
import DZNEmptyDataSet

typealias SwipeToFavoriteCellPresentable = protocol<MGSwipeTableCellDelegate, CellsFavoritable>
typealias TableViewRefreshable = protocol<ScheduleRefreshable, ScheduleViewModelDelegate>

protocol CellsFavoritable {
    func favoriteSession(indexPath: NSIndexPath)
}

protocol ScheduleRefreshable {
    func refreshData(sender: AnyObject)
}