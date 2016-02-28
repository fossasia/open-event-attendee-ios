//
//  MicrolocationProvider.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 28/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias MicrolocationsLoadingCompletionHandler = ([Microlocation]?, Error?) -> Void

struct MicrolocationProvider {
    func getMicrolocations(microlocationsLoadingCompletionHandler: MicrolocationsLoadingCompletionHandler) {
        if !SettingsManager.isKeyPresentInUserDefaults(SettingsManager.keyForMicrolocations) {
            FetchDateService().fetchData(EventInfo.Microlocations) { (error) -> Void in
                if error != nil {
                    microlocationsLoadingCompletionHandler(nil, error!)
                }
                SettingsManager.saveKeyInUserDefaults(SettingsManager.keyForMicrolocations, bool: true)
                self.getMicrolocationsFromDisk { (microlocations, error) -> Void in
                    if let microlocationsFromDisk = microlocations {
                        microlocationsLoadingCompletionHandler(microlocationsFromDisk, nil)
                    } else {
                        microlocationsLoadingCompletionHandler(nil, error)
                    }
                };
            }
            
        }
        self.getMicrolocationsFromDisk { (microlocations, error) -> Void in
            if let microlocationsFromDisk = microlocations {
                microlocationsLoadingCompletionHandler(microlocationsFromDisk, nil)
            } else {
                microlocationsLoadingCompletionHandler(nil, error)
            }
        };
    }
    
    func getMicrolocationsFromDisk(microlocationsLoadingCompletionHandler: MicrolocationsLoadingCompletionHandler) {
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first {
            do {
                let filePath = dir.stringByAppendingPathComponent(SettingsManager.getLocalFileName(EventInfo.Microlocations))
                let microlocationsData = try NSData(contentsOfFile: filePath, options: .DataReadingMappedIfSafe)
                let jsonObj = JSON(data: microlocationsData)
                guard let microlocationsArray = jsonObj[EventInfo.Microlocations.rawValue].array else {
                    let error = Error(errorCode: .JSONParsingFailed)
                    microlocationsLoadingCompletionHandler(nil, error)
                    return
                }
                
                var microlocations: [Microlocation] = []
                
                for microlocation in microlocationsArray {
                    guard let microlocationId = microlocation["id"].int,
                        microlocationName = microlocation["name"].string,
                        microlocationLatitude = Double(microlocation["latitude"].stringValue),
                        microlocationLongitude = Double(microlocation["longitude"].stringValue),
                        microlocationFloor = Int(microlocation["floor"].stringValue) else {
                            continue
                    }
                    
                    let tempMicrolocation = Microlocation(id: microlocationId,
                        name: microlocationName,
                        latitude: microlocationLatitude,
                        longitude: microlocationLongitude,
                        floor: microlocationFloor)
                    microlocations.append(tempMicrolocation)
                }
                
                microlocationsLoadingCompletionHandler(microlocations, nil)
            } catch {
                microlocationsLoadingCompletionHandler(nil, Error(errorCode: .JSONSystemReadingFailed))
            }
        }
    }
}