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

typealias SwipeToFavoriteCellPresentable = MGSwipeTableCellDelegate & CellsFavoritable
typealias TableViewRefreshable = ScheduleRefreshable & ScheduleViewModelDelegate

protocol CellsFavoritable {
    func favoriteEvent(_ indexPath: IndexPath)
}

protocol ScheduleRefreshable {
    func refreshData(_ sender: AnyObject)
}
