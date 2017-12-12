//
//  DatabaseConstants.swift
//  QOT
//
//  Created by karmic on 12.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

enum Database {

    enum Section: String {
        case learnStrategy = "LEARN_STRATEGIES"
        case learnWhatsHot = "WHAT_S_HOT"
        case prepareCoach = "prepare.coach"
        case about = "ABOUT"
        case library = "QOT_LIBRARY"

        var value: String {
            return self.rawValue
        }
    }

    enum KeyPath: String {
        case sortOrder
        case priority
    }

    enum ItemKey: String {
        case font
        case textColorRed
        case textColorGreen
        case textColorBlue
        case textColorAlpha
        case cellHeight
        case sortOrder

        var value: String {
            return self.rawValue
        }
    }

    enum QuestionGroup: String {
        case PREPARE = "Prepare"
    }
}
