//
//  Event.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct Event {
    enum Track: Int, CustomStringConvertible {
        case General = 1
        case OpenTech, DevOps, Web, Python, Mozilla, Exhibition, Workshops
        var description: String {
            switch self {
            case .General: return "General";
            case .OpenTech: return "OpenTech";
            case .DevOps: return "DevOps";
            case .Web: return "Web";
            case .Python: return "Python";
            case .Mozilla: return "Mozilla";
            case .Exhibition: return "Exhibition";
            case .Workshops: return "Workshops";
            }
        }
        
        func getTrackColor() -> UIColor {
            switch self {
            case .General:
                return UIColor(hexString: "8E8E93")!
            case .OpenTech:
                return UIColor(hexString: "FF4D55")!
            case .DevOps:
                return UIColor(hexString: "FF8C2F")!
            case .Web:
                return UIColor(hexString: "FFD233")!
            case .Python:
                return UIColor(hexString: "6CBD7A")!
            case .Mozilla:
                return UIColor(hexString: "3DC8C3")!
            case .Exhibition:
                return UIColor(hexString: "39A8FA")!
            case .Workshops:
                return UIColor(hexString: "B26DE0")!
            }
        }
    }

    let id: Int
    let trackCode: Track
    let title: String
    let shortDescription: String
    let speakers: [Speaker]?
    let location: String
    let startDateTime: NSDate
    let endDateTime: NSDate
    var favorite: Bool
}