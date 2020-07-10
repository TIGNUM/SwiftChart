//
//  MyXTeamMembersModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

enum MemberStatus: String {
    case pending
    case joined
}

struct MyXTeamMemberModel {
    var email: String?
    var status: MemberStatus = .pending
    var qotId: String? = UUID().uuidString
    var isTeamOwner: Bool = false
}
