//
//  SpeakerViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation

struct SpeakerViewModel {
    let name: Observable<String>
    
    init(_ speaker: Speaker) {
        name = Observable(speaker.name)
    }
}