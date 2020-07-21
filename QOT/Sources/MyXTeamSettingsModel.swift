//
//  MyXTeamSettingsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct MyXTeamSettingsModel {

    enum Setting: Int, CaseIterable {
        case teamName = 0
        case teamMembers
        case leaveTeam
        case deleteTeam

        static func items(is owner: Bool) -> [MyXTeamSettingsModel.Setting] {
            if owner {
                return [.teamName, .teamMembers, .deleteTeam]
            }
            return [.teamMembers, .leaveTeam]
        }

        static func item(is owner: Bool, at indexPath: IndexPath) -> MyXTeamSettingsModel.Setting {
            return items(is: owner).at(index: indexPath.row) ?? .teamMembers
        }
    }

    var teamSettingsCount: Int {
        return Setting.allCases.count
    }
}
