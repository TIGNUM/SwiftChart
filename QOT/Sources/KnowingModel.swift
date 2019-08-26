//
//  KnowingModel.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct Knowing {

    enum Section: Int, CaseIterable {
        case header = 0
        case strategies
        case whatsHot

        var titlePredicate: Tags? {
            switch self {
            case .header: return nil
            case .strategies: return .knowSectionTitleStrategies
            case .whatsHot: return .knowSectionTitleWhatsHot
            }
        }

        var subtitlePredicate: Tags? {
            switch self {
            case .header: return nil
            case .strategies: return  .knowSectionSubtitleStrategies
            case .whatsHot: return .knowSectionSubtitleWhatsHot
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
