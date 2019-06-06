//
//  KnowingModel.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Knowing {

    enum Section: Int, CaseIterable {
        case strategies = 0
        case whatsHot

        var titlePredicate: NSPredicate {
            switch self {
            case .strategies: return ContentService.Navigation.FirstLevel.knowSectionTitleStrategies.predicate
            case .whatsHot: return ContentService.Navigation.FirstLevel.knowSectionTitleWhatsHot.predicate
            }
        }

        var subtitlePredicate: NSPredicate {
            switch self {
            case .strategies: return ContentService.Navigation.FirstLevel.knowSectionSubtitleStrategies.predicate
            case .whatsHot: return ContentService.Navigation.FirstLevel.knowSectionSubtitleWhatsHot.predicate
            }
        }
    }

    struct WhatsHotItem: Equatable {
        let title: String
        let body: String
        let image: URL?
        let remoteID: Int
        let author: String
        let publishDate: Date?
        let timeToRead: String?
        let isNew: Bool
    }

    struct StrategyItem: Equatable {
        let title: String
        let remoteID: Int
        let viewedCount: Int
        let itemCount: Int
        let sortOrder: Int
    }
}
