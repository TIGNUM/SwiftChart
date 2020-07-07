//
//  TeamEditModel.swift
//  QOT
//
//  Created by karmic on 23.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum TeamEdit {
    case header
    case subHeader
    case description
    case cta

    func label(type: TeamEdit.View) -> String {
        if let key = key(type) {
            return AppTextService.get(key)
        }
        return ""
    }

    func key(_ type: TeamEdit.View) -> AppTextKey? {
        let isCreate = type == .create
        let isEdit = type == .edit
        switch self {
        case .header:
            return isCreate ? .my_x_team_create_header : isEdit ? .my_x_team_edit_header : .my_x_team_member_invite_header
        case .subHeader:
            return isCreate || isEdit ? nil : .my_x_team_member_invite_subHeader
        case .description:
            return isCreate ? .my_x_team_create_description : isEdit ? nil : .my_x_team_member_invite_description
        case .cta:
            return isCreate ? .my_x_team_create_cta : isEdit ? .my_x_team_edit_save_cta : .my_x_team_member_invite_cta
        }
    }

    enum View {
        case create
        case memberInvite
        case edit
    }
}
