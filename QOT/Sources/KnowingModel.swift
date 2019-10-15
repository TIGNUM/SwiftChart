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

        var title: String? {
            switch self {
            case .header: return nil
            case .strategies: return AppTextService.get(AppTextKey.know_view_title_55_impact)
            case .whatsHot: return AppTextService.get(AppTextKey.know_view_title_whats_hot)
            }
        }

        var subtitle: String? {
            switch self {
            case .header: return nil
            case .strategies: return AppTextService.get(AppTextKey.know_view_subtitle_learn_strategies)
            case .whatsHot: return AppTextService.get(AppTextKey.know_view_subtitle_curated_content)
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
