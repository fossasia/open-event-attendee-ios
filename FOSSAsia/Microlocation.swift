//
//  Microlocation.swift
//  FOSSAsia
//
//  Created by Pratik Todi on 28/02/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct Microlocation {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let floor: Int

    static func getNameOfMicrolocationId(_ id: Int, microlocations: [Microlocation]) -> String? {
	for microlocation in microlocations {
	    if microlocation.id == id {
		return microlocation.name
	    }
	}
	return nil
    }
}
