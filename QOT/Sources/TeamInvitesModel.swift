//
//  TeamInvitesModel.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

struct TeamInvite {
    enum Section: Int, CaseIterable {
        case header = 0
        case invite
    }

    struct Header {
        let title: String
        let content: String
    }

    struct Invitation {
        let teamId: String
        let teamName: String
        let teamColor: String
        let sender: String
        let dateOfInvite: String
        let memberCount: Int
        let warningMessage: String

        func canJoin(maxTeams: Int, partOfTeams: Int) -> Bool {
            return partOfTeams < maxTeams
        }
    }
}
