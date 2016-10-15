//
//  FilterCell.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 4/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit

typealias TrackDetailsWithSwitchPresentable = TrackDetailsPresentable & TrackStatusPresentable & TrackColorPresentable

class FilterCell: UITableViewCell {
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var trackIndicator: UIView!
    @IBOutlet weak var trackSwitch: UISwitch!
    
    fileprivate var delegate: TrackDetailsWithSwitchPresentable?
    
    func configure(_ presenter: TrackDetailsWithSwitchPresentable) {
        delegate = presenter
        trackLabel.text = presenter.trackName
        trackIndicator.backgroundColor = presenter.trackColor
        if let filterPrefs = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.FilteredTrackIds) as? [Int] {
            trackSwitch.isOn = filterPrefs.contains(presenter.trackId)
        }
        trackSwitch.addTarget(self, action: #selector(FilterCell.switchFlipped(_:)), for: .valueChanged)
    }
    
    func switchFlipped(_ sender: AnyObject) {
        if let filterSwitch = sender as? UISwitch {
            delegate?.changeFilterPreference(filterSwitch.isOn)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackIndicator.layer.cornerRadius = trackIndicator.frame.size.width / 2
    }
}
