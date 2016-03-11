//
//  SettingsManager.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 27/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct SettingsManager {

    static let keyForSession = "HasSessions"
    static let keyForRefresh = "CanRefresh"
    static let keyForMicrolocations = "HasMicrolocations"

    static let favouritesLocalFileName = "faves.json"
    
    static func isSessionDataLoaded() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(SettingsManager.keyForSession)
    }
    
    static func isRefreshAllowed() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(SettingsManager.keyForRefresh)
    }
    
    static func setKeyForRefresh(bool: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(bool, forKey: SettingsManager.keyForRefresh)
    }
    

    static func saveKeyInUserDefaults(key: String, bool: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(bool, forKey: key)
    }

    static func getLocalFileName(eventInfo: EventInfo) -> String {
        return eventInfo.rawValue + ".json"
    }

}