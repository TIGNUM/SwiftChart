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
    }

    var teamSettingsCount: Int {
        return Setting.allCases.count
    }
}
