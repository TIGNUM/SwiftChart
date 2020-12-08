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
        var models: [BaseDailyBriefViewModel] = []
//        let converter = MyLibraryCellViewModelConverter()
        let vision = bucket.teamToBeVisions?.filter { !$0.sentences.isEmpty }.first
        guard vision != nil else { return models }
        let imageURL = vision?.profileImageResource?.remoteURLString == nil ? bucket.imageURL : vision?.profileImageResource?.remoteURLString
        for teamQotId in teamQotIds {
            let filteredFeeds = libraryFeeds.filter({ $0.teamQotId == teamQotId })
            guard let firstFeed = filteredFeeds.first, let team = firstFeed.team,
                firstFeed.teamStorage != nil else {
                    continue
            }
            models.append(TeamNewsFeedDailyBriefViewModel(team: team, title: "Team library", itemsAdded: filteredFeeds.count, imageURL: imageURL, domainModel: bucket))
        }
        return models
    }
}
