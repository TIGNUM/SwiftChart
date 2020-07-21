//
//  BookMarkSelectionWorker.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class BookMarkSelectionWorker {

    // MARK: - Properties

    // MARK: - Init

    init() {}

    public func viewModels(from bookMarks: [QDMUserStorage], _ completion: @escaping ([BookMarkSelectionModel]) -> Void) {
        var viewModels = [BookMarkSelectionModel]()
        // add private
        let existingPrivateBookmark = bookMarks.filter({ $0.teamQotId == nil && ($0.teamId ?? 0 == 0) }).first
        viewModels.append(BookMarkSelectionModel(nil, existingPrivateBookmark))
        TeamService.main.getTeams { (teams, _, _) in
            for team in teams ?? [] {
                let existingTeamBookmark = bookMarks.filter({ $0.teamQotId == team.qotId }).first
                viewModels.append(BookMarkSelectionModel(team, existingTeamBookmark))
            }
            completion(viewModels)
        }
    }
}
