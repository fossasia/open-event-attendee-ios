//
//  SchedulePagingView.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 11/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit


class SchedulePagingView: UIView {
    
    weak var delegate: SchedulePagingViewDelegate?
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func prevButtonPressed(_ sender: AnyObject) {
        delegate?.prevButtonDidPress(self)
    }
    
    @IBAction func nextButtonPressed(_ sender: AnyObject) {
        delegate?.nextButtonDidPress(self)
    }
}
