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
        case guide = 101180
        case learn = 101178
        case me = 101179
        case data = 101181
        case prepare = 101182
        case dailyPrep = 101175
        case toBeVision = 101176
    }

    struct Item {
        let title: String
        let imageURL: URL?
        let videoURL: URL?
        let message: String
    }
}
