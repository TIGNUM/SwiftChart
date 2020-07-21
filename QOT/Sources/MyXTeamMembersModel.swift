//
//  MyXTeamMembersModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct TeamMember {
    enum Status: String {
        case pending
        case joined
    }

    let member: QDMTeamMember
    let email: String?
    var status: TeamMember.Status = .pending
    let qotId: String?
    var isTeamOwner: Bool = false
    var wasReinvited: Bool = false
}
