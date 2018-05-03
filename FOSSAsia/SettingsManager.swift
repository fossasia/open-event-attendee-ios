//
//  SettingsManager.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct SettingsManager {

    static let keyForEvent = Constants.SettingsManager.keyForEvent
    static let keyForMicrolocations = Constants.SettingsManager.keyForMicrolocations

    static let favouritesLocalFileName = Constants.SettingsManager.favesJSON

    static func isKeyPresentInUserDefaults(_ key: String) -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: key)
    }

    static func saveKeyInUserDefaults(_ key: String, bool: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(bool, forKey: key)
    }

    static func getLocalFileName(_ eventInfo: EventInfo) -> String {
        return eventInfo.rawValue + Constants.jsonFileExtension
    }

}
