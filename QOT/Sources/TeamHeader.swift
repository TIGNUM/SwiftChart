//
//  Team.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit
import qot_dal

struct Team {
    static let KeyTeamId = "team.key.team.id"
    static let KeyColor = "team.key.team.colot"
    static let keyInvite = "team.key.invite"

    enum Header: Int, CaseIterable, Differentiable {
        case invite = 0
        case team

        var inviteId: String {
            switch self {
            case .invite: return UUID().uuidString
            case .team: return ""
            }
        }

        var title: String {
            switch self {
            case .invite: return AppTextService.get(.team_invite_header_singular)
            case .team: return ""
            }
        }
    }

    final class Item: Differentiable {
        typealias DifferenceIdentifier = String

        var header: Team.Header
        var title: String
        var teamId: String
        var color: String = ""
        var selected: Bool = false
        var batchCount: Int = 0

        /// Init here Team.Item
        init(title: String, teamId: String, color: String) {
            self.header = .team
            self.title = title
            self.teamId = teamId
            self.color = color
        }

        /// Team.Item
        init(batchCount: Int) {
            self.header = .invite
            self.title = Team.Header.invite.title
            self.teamId = Team.Header.invite.inviteId
            self.batchCount = batchCount
        }

        /// Invite.Item
        var differenceIdentifier: DifferenceIdentifier {
            return teamId
        }

        func isContentEqual(to source: Item) -> Bool {
            return title == source.title &&
                color == source.color &&
                selected == source.selected &&
                batchCount == source.batchCount
        }
    }
}

//struct Team {
//    enum Selector: String {
//        case teamId
//        case teamColor
//        case teamInvites
//    }
//
//    struct Invite: Differentiable {
//        typealias DifferenceIdentifier = String
//
//        var title: String
//        var counter: Int
//
//        var differenceIdentifier: DifferenceIdentifier {
//            return title
//        }
//
//        func isContentEqual(to source: Team.Invite) -> Bool {
//            return counter == source.counter
//        }
//    }
//}

//
//struct TeamHeader {
//    enum Selector: String {
//        case teamId
//        case teamColor
//        case teamInvites
//    }
//
//    class InviteButton {
//        var title: String
//        var counter: Int
//
//        init(title: String, counter: Int) {
//            self.title = title
//            self.counter = counter
//        }
//    }
//
//    class Item: Differentiable {
//        typealias DifferenceIdentifier = String
//
//        var inviteButton: InviteButton?
//        var teamId: String = ""
//        var title: String = ""
//        var hexColorString: String = ""
//        var selected: Bool = false
//
//        var differenceIdentifier: DifferenceIdentifier {
//            return teamId
//        }
//
//        init(inviteButton: InviteButton) {
//            self.inviteButton = inviteButton
//        }
//
//        init(teamId: String,
//             title: String,
//             hexColorString: String,
//             selected: Bool) {
//            self.teamId = teamId
//            self.title = title
//            self.hexColorString = hexColorString
//            self.selected = selected
//        }
//
//        func isContentEqual(to source: Team.Item) -> Bool {
//            return teamId == source.teamId &&
//                title == source.title &&
//                hexColorString == source.hexColorString &&
//                selected == source.selected
//        }
//    }
//}

    //    struct Invitation: Differentiable {
    //        typealias DifferenceIdentifier = String
    //
    //        let teamId: String
    //        let teamName: String
    //        let teamColor: String
    //        let sender: String
    //        let date: String
    //        let memberCount: Int
    //
    //        var differenceIdentifier: DifferenceIdentifier {
    //            return teamId
    //        }
    //
    //        func isContentEqual(to source: Team.Invitation) -> Bool {
    //            return teamId == source.teamId &&
    //                teamName == source.teamName &&
    //                teamColor == source.teamName &&
    //                sender == source.sender &&
    //                date == source.date &&
    //                memberCount == source.memberCount
    //        }
    //    }
