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
    func createTeamNewFeedViewModel(with bucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        let libraryFeeds = bucket.teamNewsFeeds?.filter({
            $0.teamNewsFeedActionType == .STORAGE_ADDED && $0.teamStorage?.isMine == false
        }) ?? []
        guard libraryFeeds.isEmpty == false else { return [] }
        let teamQotIds = Set(libraryFeeds.compactMap({ $0.teamStorage?.teamQotId })).sorted()
        var models = [TeamNewsFeedDailyBriefViewModel]()
        let converter = MyLibraryCellViewModelConverter()
        for teamQotId in teamQotIds {
            let filteredFeeds = libraryFeeds.filter({ $0.teamQotId == teamQotId })
            guard let firstFeed = filteredFeeds.first, let team = firstFeed.team,
                firstFeed.teamStorage != nil else {
                    continue
            }
            // create header
            let header = TeamNewsFeedDailyBriefViewModel(type: .header, team: team,
                                                         title: team.name ?? "TEAM Library",
                                                         subtitle: "added items",
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
                                                         buttonTitle: "OPEN LIBRARY", domainModel: bucket)
            models.append(footer)
        }

        return models
    }
}
