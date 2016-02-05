//
//  FilterCell.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 4/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

typealias TrackDetailsWithSwitchPresentable = protocol<TrackDetailsPresentable, TrackStatusPresentable, TrackColorPresentable>

class FilterCell: UITableViewCell {
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var trackIndicator: UIView!
    @IBOutlet weak var trackSwitch: UISwitch!
    
    private var delegate: TrackDetailsWithSwitchPresentable?
    
    func configure(presenter: TrackDetailsWithSwitchPresentable) {
        delegate = presenter
        trackLabel.text = presenter.trackName
        trackIndicator.backgroundColor = presenter.trackColor
        if let filterPrefs = NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaultsKey.FilteredTrackIds) as? [Int] {
            trackSwitch.on = filterPrefs.contains(presenter.trackId)
        }
        trackSwitch.addTarget(self, action: "switchFlipped:", forControlEvents: .ValueChanged)
    }
    
    func switchFlipped(sender: AnyObject) {
        if let filterSwitch = sender as? UISwitch {
            delegate?.changeFilterPreference(filterSwitch.on)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackIndicator.layer.cornerRadius = trackIndicator.frame.size.width / 2
    }
}
