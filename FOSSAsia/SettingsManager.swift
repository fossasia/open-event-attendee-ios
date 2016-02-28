//
//  SettingsManager.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct SettingsManager {

    static let keyForEvent = "HasEvents"
    static let keyForMicrolocations = "HasMicrolocations"

    static let favouritesLocalFileName = "faves.json"

    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(key)
    }

    static func saveKeyInUserDefaults(key: String, bool: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(bool, forKey: key)
    }

    static func getLocalFileName(eventInfo: EventInfo) -> String {
        return eventInfo.rawValue + ".json"
    }

}