//
//  EventCell.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

typealias EventCellWithTypePresentable = protocol<EventTypePresentable, EventDetailsPresentable>

class EventCell: UITableViewCell {
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    private var delegate: EventCellWithTypePresentable?
    
    func configure(withPresenter presenter: EventCellWithTypePresentable) {
        delegate = presenter
        titleLabel.text = delegate!.eventName
        typeView.backgroundColor = delegate!.typeColor
        timingLabel.text = delegate!.timing
    }
    
}
