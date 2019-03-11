//
//  SiriShortcutsModels.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

enum ShortcutType: Int, CaseIterable {
    case toBeVision = 0
    case upcomingEventPrep
    case morningInterview
    case whatsHot
}

struct SiriShortcutsModel {
    let explanation: String?
    let shortcuts: [Shortcut]

    struct Shortcut {
        let type: ShortcutType
        let title: String?
        let suggestion: String?
    }
}
