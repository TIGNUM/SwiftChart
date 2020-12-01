//
//  TeamNewsFeedDailyBriefViewModel.swift
//  QOT
//
//  Created by Sanggeon Park on 05.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamNewsFeedDailyBriefViewModel: BaseDailyBriefViewModel, Hashable {
    enum NewsFeedCellType: String {
        case header
        case storageItem
        case buttonAction
    }
    // MARK: - Properties
    let type: TeamNewsFeedDailyBriefViewModel.NewsFeedCellType
    let subtitle: String?
    let actionButtonTitle: String?
    let feed: QDMTeamNewsFeed?
    let team: QDMTeam
    var libraryCellViewModel: MyLibraryCellViewModel?

    // MARK: - Init
    init(type: TeamNewsFeedDailyBriefViewModel.NewsFeedCellType, team: QDMTeam,
         title: String?, subtitle: String?, feed: QDMTeamNewsFeed?, buttonTitle: String?,
         domainModel: QDMDailyBriefBucket?) {
        self.type = type
        self.team = team
        self.subtitle = subtitle
        self.feed = feed
        self.actionButtonTitle = buttonTitle
        super.init(domainModel, title: title)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? TeamNewsFeedDailyBriefViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            type == source.type &&
            team.qotId == source.team.qotId &&
            feed?.teamStorage?.userStorageType == source.feed?.teamStorage?.userStorageType &&
            feed?.teamStorage?.mediaType == source.feed?.teamStorage?.mediaType &&
            feed?.teamStorage?.contentType == source.feed?.teamStorage?.contentType &&
            feed?.teamStorage?.contentId == source.feed?.teamStorage?.contentId &&
            feed?.teamStorage?.note == source.feed?.teamStorage?.note &&
            feed?.teamStorage?.url == source.feed?.teamStorage?.url &&
            actionButtonTitle == source.actionButtonTitle
    }

    public static func == (lhs: TeamNewsFeedDailyBriefViewModel, rhs: TeamNewsFeedDailyBriefViewModel) -> Bool {
        return lhs.isContentEqual(to: rhs)
    }

    public func hash(into hasher: inout Hasher) {
        var defaultString = self.domainModel?.bucketName ?? ""
        defaultString += team.qotId ?? ""
        defaultString += actionButtonTitle ?? ""
        defaultString += feed?.teamStorage?.note ?? ""
        defaultString += feed?.teamStorage?.url ?? ""
        defaultString += feed?.teamStorage?.userStorageType.rawValue ?? ""
        defaultString += feed?.teamStorage?.mediaType?.rawValue ?? ""
        defaultString += feed?.teamStorage?.contentType.rawValue ?? ""
        defaultString += feed?.teamStorage?.contentId ?? ""
        defaultString.hash(into: &hasher)
    }
}
