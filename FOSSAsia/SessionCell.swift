//
//  SessionCell.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import MGSwipeTableCell

typealias SessionCellWithTypePresentable = protocol<SessionTypePresentable, SessionDetailsPresentable>

class SessionCell: MGSwipeTableCell {
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    
    private var viewModel: SessionCellWithTypePresentable?
    
    func configure(withPresenter presenter: SessionCellWithTypePresentable) {
        viewModel = presenter
        titleLabel.text = viewModel!.sessionName
        typeView.backgroundColor = viewModel!.typeColor
        timingLabel.text = viewModel!.timing
        if (viewModel!.isFavorite) {
            favoriteImage.transform = CGAffineTransformIdentity
            favoriteImage.alpha = 1.0
        } else {
            favoriteImage.transform = CGAffineTransformMakeScale(0.1, 0.1)
            favoriteImage.alpha = 0.0
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        let color = typeView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            typeView.backgroundColor = color
            self.contentView.backgroundColor = UIColor(hexString: "FFF5F5")
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let color = typeView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            typeView.backgroundColor = color
        
            self.contentView.backgroundColor = UIColor(hexString: "FFF5F5")
        }
    }
    
}
