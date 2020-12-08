//
//  TeamNewsFeedDailyBriefViewModel.swift
//  QOT
//
//  Created by Sanggeon Park on 05.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamNewsFeedDailyBriefViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
//    let type: TeamNewsFeedDailyBriefViewModel.NewsFeedCellType
//    let subtitle: String?
//    let actionButtonTitle: String?
//    let feed: QDMTeamNewsFeed?
    let team: QDMTeam
    var libraryCellViewModel: MyLibraryCellViewModel?

    // MARK: - Init
    init(
         team: QDMTeam,
         title: String?,
         itemsAdded: Int?,
         imageURL: String?,
         domainModel: QDMDailyBriefBucket?) {
        self.team = team
        super.init(domainModel,
                   title: title,
                   body: "You have ${numberOfItems} new item(s) shared in ${team} library.",
                   image: imageURL,
                   titleColor: team.teamColor)
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? TeamNewsFeedDailyBriefViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            title == source.title &&
            team.qotId == source.team.qotId
    }

    public static func == (lhs: TeamNewsFeedDailyBriefViewModel, rhs: TeamNewsFeedDailyBriefViewModel) -> Bool {
        return lhs.isContentEqual(to: rhs)
    }
}
