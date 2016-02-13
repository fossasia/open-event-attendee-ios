//
//  ScheduleBrowsingProtocol.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 13/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation
import MGSwipeTableCell

typealias SwipeToFavoriteCellPresentable = protocol<MGSwipeTableCellDelegate, CellsFavoritable>

protocol CellsFavoritable {
    func favoriteEvent(indexPath: NSIndexPath)
}