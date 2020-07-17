//
//  MyXTeamSettingsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyXTeamSettingsWorker: WorkerTeam {

    lazy var teamSettingsText = AppTextService.get(.settings_team_settings_title).uppercased()

    lazy var settings = MyXTeamSettingsModel()

    func settingItems(team: QDMTeam) -> [MyXTeamSettingsModel.Setting] {
        //        if team.thisUserIsOwner {
        //            return [.teamName, .teamMembers, .deleteTeam]
        //        } else {
        //            return [.teamMembers, .leaveTeam]
        //        }
        //        TEMP: ALL OPTIONS
        return [.teamName, .teamMembers, .leaveTeam, .deleteTeam]
    }
}
