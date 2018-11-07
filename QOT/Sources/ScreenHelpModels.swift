//
//  HelpModels.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

enum ScreenHelp {

    enum Category: Int {
        case guide = 100748
        case learn = 100745
        case me = 100746
        case prepare = 100747
        case dailyPrep = 101157
        case toBeVision = 101163
    }

    struct Item {
        let title: String
        let imageURL: URL
        let videoURL: URL
        let message: String
    }
}
