//
//  Notification+Ext.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension Notification.Name {

    static let didFinishDailyCheckin = Notification.Name("didFinishDailyCheckin")
    static let didPickTarget = Notification.Name("didPickTarget")
    static let didSelectTeam = Notification.Name("didSelectTeam")
    static let didSelectMyX = Notification.Name("didSelectMyX")
    static let didSelectTeamColor = Notification.Name("didSelectTeamColor")
    static let updatedTeams = Notification.Name("updatedTeams")
    static let didSelectTeamInvite = Notification.Name("didSelectTeamInvite")
    static let didSelectTeamInviteDecline = Notification.Name("didSelectTeamInviteDecline")
    static let didSelectTeamInviteJoin = Notification.Name("didSelectTeamInviteJoin")
    static let changedInviteStatus = Notification.Name("changedInviteStatus")
    static let didVoteTeamTBV = Notification.Name("didVoteTeamTBV")
    static let didUnVoteTeamTBV = Notification.Name("didUnVoteTeamTBV")
}
