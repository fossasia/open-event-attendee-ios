//
//  SessionInfoView.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 31/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

class SessionInfoView: UIView {
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    private var delegate: SessionDetailsPresentable?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sessionLabel.preferredMaxLayoutWidth = sessionLabel.bounds.size.width
        speakerLabel.preferredMaxLayoutWidth = speakerLabel.bounds.size.width
        locationLabel.preferredMaxLayoutWidth = locationLabel.bounds.size.width
        super.layoutSubviews()
    }
    
    func configure(presenter: SessionDetailsPresentable) {
        delegate = presenter
        
        if let delegate = self.delegate {
            sessionLabel.text = delegate.sessionName
            speakerLabel.text = delegate.speakerNames
            locationLabel.text = delegate.timing
        }
    }
}
