//
//  TeamHeader.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

final class TeamHeader {
    var teamInvites: [TeamInvitation] = []
    var teamId: String = ""
    var title: String = ""
    var hexColorString: String = ""
    var sortOrder: Int = 0
    var batchCount: Int = 0
    var selected: Bool = false

    enum Selector: String {
        case teamId
        case teamColor
        case teamInvites
    }

    enum View {
        case myX
        case settings
    }

    init(teamInvites: [TeamInvitation]) {
        self.teamInvites = teamInvites
    }

    init(teamId: String,
         title: String,
         hexColorString: String,
         sortOrder: Int,
         batchCount: Int,
         selected: Bool) {
        self.teamId = teamId
        self.title = title
        self.hexColorString = hexColorString
        self.sortOrder = sortOrder
        self.batchCount = batchCount
        self.selected = selected
    }
}
