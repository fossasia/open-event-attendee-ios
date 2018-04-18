//
//  EventCell.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import MGSwipeTableCell

typealias EventCellWithTypePresentable = EventTypePresentable & EventDetailsPresentable

class EventCell: MGSwipeTableCell {
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!

    fileprivate var viewModel: EventCellWithTypePresentable?

    func configure(withPresenter presenter: EventCellWithTypePresentable) {
        viewModel = presenter
        titleLabel.text = viewModel!.eventName
        typeView.backgroundColor = viewModel!.typeColor
        timingLabel.text = viewModel!.timing
        if (viewModel!.isFavorite) {
            favoriteImage.transform = CGAffineTransform.identity
            favoriteImage.alpha = 1.0
        } else {
            favoriteImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            favoriteImage.alpha = 0.0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = typeView.backgroundColor
        super.setSelected(selected, animated: animated)

        if selected {
            typeView.backgroundColor = color
            self.contentView.backgroundColor = Colors.highlightedBackgroundColor
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = typeView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)

        if highlighted {
            typeView.backgroundColor = color

            self.contentView.backgroundColor = Colors.highlightedBackgroundColor
        }
    }

}
