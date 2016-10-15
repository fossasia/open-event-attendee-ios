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
        case techKids1 = 1
        case techKids2, openTechIOT, openTech, webTech, exhibition, hardwareIOT, python, databases, bigOpenData, devOps, privSec, isc, scienceHackDay, linux, design
        var description: String {
            switch self {
            case .techKids1: return "Tech Kids I";
            case .techKids2: return "Tech Kids II";
            case .openTechIOT: return "OpenTech and IOT";
            case .openTech: return "OpenTech Workshops";
            case .webTech: return "WebTech";
            case .exhibition: return "Exhibition";
            case .hardwareIOT: return "Hardware and IOT";
            case .python: return "Python";
            case .databases: return "Databases";
            case .bigOpenData: return "Big Data/Open Data";
            case .devOps: return "DevOps";
            case .privSec: return "Privacy and Security";
            case .isc: return "Internet, Society, Community";
            case .scienceHackDay: return "Science Hack Day";
            case .linux: return "Linux and MiniDebConf";
            case .design: return "Design, VR, 3D"
            }
        }
        
        func getTrackColor() -> UIColor {
            switch self {
            case .techKids1, .techKids2:
                return UIColor(hexString: "8E8E93")!
            case .openTechIOT:
                return UIColor(hexString: "FF4D4D")!
            case .openTech:
                return UIColor(hexString: "FF8E4C")!
            case .webTech:
                return UIColor(hexString: "FFCF4C")!
            case .exhibition:
                return UIColor(hexString: "EAFF4C")!
            case .hardwareIOT:
                return UIColor(hexString: "B8FF4C")!
            case .python:
                return UIColor(hexString: "85FF4C")!
            case .databases:
                return UIColor(hexString: "50E3C2")!
            case .bigOpenData:
                return UIColor(hexString: "4CFFE7")!
            case .devOps:
                return UIColor(hexString: "4CDBFF")!
            case .privSec:
                return UIColor(hexString: "4CA9FF")!
            case .isc:
                return UIColor(hexString: "7C4CFF")!
            case .scienceHackDay:
                return UIColor(hexString: "9D4CFF")!
            case .linux:
                return UIColor(hexString: "ED4CFF")!
            case .design:
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
    let startDateTime: Date
    let endDateTime: Date
    var favorite: Bool
}
