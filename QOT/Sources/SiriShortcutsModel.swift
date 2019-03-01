//
//  SiriShortcutsModels.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct SiriShortcutsModel {

    enum Shortcut: Int, CaseIterable {
        case toBeVision = 0
        case upcomingEventPrep
        case morningInterview
        case whatsHot

        var title: String {
            switch self {
            case .toBeVision: return R.string.localized.siriShortcutsToBeVisionTitle()
            case .upcomingEventPrep: return R.string.localized.siriShortcutsUpcomingEventPrepTitle()
            case .whatsHot: return R.string.localized.siriShortcutsWhatsHotArticleTitle()
            case .morningInterview: return R.string.localized.siriShortcutsDailyPrepTitle()
            }
        }
    }

    // MARK: - Properties

    private let services: Services
    var itemCount: Int {
        return Shortcut.allCases.count
    }

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }

    // MARK: - Functions

    func shortcutItem(at indexPath: IndexPath) -> Shortcut {
        return Shortcut.allCases.item(at: indexPath.row)
    }
}
