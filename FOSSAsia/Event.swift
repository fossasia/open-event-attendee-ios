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
        case OpenTechIOT = 1
        case OpenTech, TechKids1, TechKids2, TechKids3, HardwareIOT, DevOps, WebTech, Python, BigOpenData, Databases, ISC, PrivSec, ScienceHackDay, Linux, Design, Exhibition, Social
        var description: String {
            switch self {
            case .TechKids1: return "Tech Kids I";
            case .TechKids2: return "Tech Kids II";
            case .TechKids3: return "Tech Kids III"
            case .OpenTechIOT: return "OpenTech and IOT";
            case .OpenTech: return "OpenTech Workshops";
            case .WebTech: return "WebTech";
            case .Exhibition: return "Exhibition";
            case .HardwareIOT: return "Hardware and IOT";
            case .Python: return "Python";
            case .Databases: return "Databases";
            case .BigOpenData: return "Big Data/Open Data";
            case .DevOps: return "DevOps";
            case .PrivSec: return "Privacy and Security";
            case .ISC: return "Internet, Society, Community";
            case .ScienceHackDay: return "Science Hack Day";
            case .Linux: return "Linux and MiniDebConf";
            case .Design: return "Design, VR, 3D";
            case .Social: return "Social Event";
            }
        }
        
        func getTrackColor() -> UIColor {
            switch self {
            case .TechKids1, .TechKids2, .TechKids3, .Social:
                return UIColor(hexString: "8E8E93")!
            case .OpenTechIOT:
                return UIColor(hexString: "FF4D4D")!
            case .OpenTech:
                return UIColor(hexString: "FF8E4C")!
            case .WebTech:
                return UIColor(hexString: "FFCF4C")!
            case .Exhibition:
                return UIColor(hexString: "EAFF4C")!
            case .HardwareIOT:
                return UIColor(hexString: "B8FF4C")!
            case .Python:
                return UIColor(hexString: "85FF4C")!
            case .Databases:
                return UIColor(hexString: "50E3C2")!
            case .BigOpenData:
                return UIColor(hexString: "4CFFE7")!
            case .DevOps:
                return UIColor(hexString: "4CDBFF")!
            case .PrivSec:
                return UIColor(hexString: "4CA9FF")!
            case .ISC:
                return UIColor(hexString: "7C4CFF")!
            case .ScienceHackDay:
                return UIColor(hexString: "9D4CFF")!
            case .Linux:
                return UIColor(hexString: "ED4CFF")!
            case .Design:
                return UIColor(hexString: "FF4CCC")!
            }
        }
    }

    let id: String
    let trackCode: Track
    let title: String
    let shortDescription: String
    let speakers: [Speaker]?
    let location: String
    let startDateTime: NSDate
    let endDateTime: NSDate
    var favorite: Bool
}