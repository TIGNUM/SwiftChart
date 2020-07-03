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

    let contentService: ContentService

    init(contentService: ContentService) {
        self.contentService = contentService
    }

    enum Setting: Int {
        case teamName = 0
        case teamMembers
        case leaveTeam
        case deleteTeam

        static var teamSettings: [Setting] {
            return [.teamName, .teamMembers, .leaveTeam, .deleteTeam]
        }
    }

    var teamSettingsCount: Int {
        return Setting.teamSettings.count
    }

    func titleForItem(at indexPath: IndexPath) -> String {
        return title(for: Setting.teamSettings.at(index: indexPath.row) ?? .teamName) ?? ""
    }

    func subtitleForItem(at indexPath: IndexPath) -> String {
        return subtitle(for: Setting.teamSettings.at(index: indexPath.row) ?? .teamName) ?? ""
       }

    private func title(for item: Setting) -> String? {
           switch item {
           case .teamName:
               return "abcdefghijklmnopqrst"
           case .teamMembers:
            return AppTextService.get(.settings_team_settings_team_members)
           case .leaveTeam:
               return AppTextService.get(.settings_team_settings_leave_team)
           case .deleteTeam:
               return AppTextService.get(.settings_team_settings_delete_team)
           }
       }

    private func subtitle(for item: Setting) -> String? {
           switch item {
           case .leaveTeam:
               return AppTextService.get(.settings_team_settings_leave_team_subtitle)
           case .deleteTeam:
               return AppTextService.get(.settings_team_settings_delete_team_subtitle)
           default: return nil
           }
       }

}
