//
//  DatabaseConstants.swift
//  QOT
//
//  Created by karmic on 12.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum Database {

    enum Section: String {
        case learnStrategy = "LEARN_STRATEGIES"
        case learnWhatsHot = "WHAT_S_HOT"
        case prepareCoach = "prepare.coach"
        case about = "ABOUT"
        case library = "QOT_LIBRARY"
        case tools = "TOOLS"
        case onBoarding = "ON_BOARDING"
        case prepare = "PREPARE"
        case faq = "FAQ"
        case help = "HELP"
        case slideShow = "SLIDESHOW_"
        case slideShowShort = "SLIDESHOW_SHORT"
        case slideShowLong = "SLIDESHOW_LONG"
        case visionGenerator = "TBV_GENERATOR"
        case feedbackMessage = "FEEDBACK_MESSAGE"
        case partnersLandingPage = "PARTNERS_LANDING_PAGE"

        var value: String {
            return rawValue
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
            return rawValue
        }
    }

    enum QuestionGroup: String {
        case PREPARE = "Prepare"
    }
}
