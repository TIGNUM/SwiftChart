//
//  DailyBriefInteractor+TeamBuckets.swift
//  QOT
//
//  Created by Sanggeon Park on 04.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension DailyBriefInteractor {
    func createTeamNewsFeedViewModel(with bucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        let libraryFeeds = bucket.teamNewsFeeds?.filter({
            $0.teamNewsFeedActionType == .STORAGE_ADDED && $0.teamStorage?.isMine == false
        }) ?? []
        guard libraryFeeds.isEmpty == false else { return [] }
        let teamQotIds = Set(libraryFeeds.compactMap({ $0.teamStorage?.teamQotId })).sorted()
        var models = [TeamNewsFeedDailyBriefViewModel]()
        let converter = MyLibraryCellViewModelConverter()
        let subtitleForOneItem = AppTextService.get(.daily_brief_section_team_news_feed_subtitle_for_one_item)
        let subtitleForMultipleItems = AppTextService.get(.daily_brief_section_team_news_feed_subtitle_for_multiple_items)
        let openLibraryButtonTitle = AppTextService.get(.daily_brief_section_team_news_feed_open_library_button_title)
        for teamQotId in teamQotIds {
            let filteredFeeds = libraryFeeds.filter({ $0.teamQotId == teamQotId })
            guard let firstFeed = filteredFeeds.first, let team = firstFeed.team,
                firstFeed.teamStorage != nil else {
                    continue
            }
            // create header
            let subtitleCount = filteredFeeds.count == 1 ? subtitleForOneItem :
                subtitleForMultipleItems.replacingOccurrences(of: "${COUNT OF FEEDS}", with: "\(filteredFeeds.count)")
            let subtitle = subtitleCount.replacingOccurrences(of: "${NAME OF THE TEAM}", with: team.name ?? "")
            let header = TeamNewsFeedDailyBriefViewModel(type: .header, team: team,
                                                         title: AppTextService.get(.daily_brief_section_team_news_feed_library).replacingOccurrences(of: "${TEAM_NAME}", with: team.name?.uppercased() ?? ""),
                                                         subtitle: subtitle,
                                                         feed: firstFeed,
                                                         buttonTitle: nil, domainModel: bucket)
            models.append(header)
            var itemModels = [TeamNewsFeedDailyBriefViewModel]()
            let count = filteredFeeds.count
            for (index, feed) in filteredFeeds.enumerated() {
                guard let storage = feed.teamStorage else { continue }
                let item = TeamNewsFeedDailyBriefViewModel(type: .storageItem, team: team,
                                                           title: nil, subtitle: nil, feed: feed,
                                                           buttonTitle: nil, domainModel: bucket)
                item.libraryCellViewModel = converter.viewModel(from: storage, team: team, downloadStatus: nil)
                if count == index + 1 {
                    item.libraryCellViewModel?.hideBottomSeparator = true
                }
                itemModels.append(item)
            }

            models.append(contentsOf: Array(Set(itemModels)).sorted(by: { (first, second) -> Bool in
                first.feed?.createdAt ?? Date() > second.feed?.createdAt ?? Date()
            }))

            let footer = TeamNewsFeedDailyBriefViewModel(type: .buttonAction, team: team,
                                                         title: nil, subtitle: nil, feed: firstFeed,
                                                         buttonTitle: openLibraryButtonTitle, domainModel: bucket)
            models.append(footer)
        }

        return models
    }
}
