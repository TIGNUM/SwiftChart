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
        case header(title: String, subtitle: String)
        case calendar(title: String, subtitle: String)
        case question(title: String)
        case perceived(title: String)
        case know(title: String)
        case feel(title: String)
        case benefits(title: String, subtitle: String)
        case strategies(title: String)

        func sectionCount(level: QDMUserPreparation.Level) -> Int {
            return level == .LEVEL_CRITICAL ? 8 : 7
        }
    }
}
