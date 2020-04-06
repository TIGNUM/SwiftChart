//
//  ResultsPrepareModel.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct ResultsPrepare {
    enum Sections {
        case header(title: String)
        case calendar(title: String, subtitle: String)
        case calendarConnect(title: String, subtitle: String)
        case title(title: String)
        case perceived(title: String, preceiveAnswers: [QDMAnswer])
        case know(title: String, knowAnswers: [QDMAnswer])
        case feel(title: String, feelAnswers: [QDMAnswer])
        case benefits(title: String, subtitle: String, benefits: String)
        case strategyTitle(title: String)
        case strategies(strategies: [QDMContentCollection])
        case strategyItems(strategyItems: [QDMContentItem])
    }

    static func sectionCount(level: QDMUserPreparation.Level) -> Int {
        return level == .LEVEL_CRITICAL ? 10 : 9
    }
}
