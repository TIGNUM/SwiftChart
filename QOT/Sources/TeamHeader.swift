//
//  TeamHeader.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit
import qot_dal

struct TeamHeader {
    enum Selector: String {
        case teamId
        case teamColor
        case teamInvites
    }

    class InviteButton {
        var title: String
        var counter: Int

        init(title: String, counter: Int) {
            self.title = title
            self.counter = counter
        }
    }

    class Item: Differentiable {
        typealias DifferenceIdentifier = String

        var inviteButton: InviteButton?
        var teamId: String = ""
        var title: String = ""
        var hexColorString: String = ""
        var selected: Bool = false

        var differenceIdentifier: DifferenceIdentifier {
            return teamId
        }

        init(inviteButton: InviteButton) {
            self.inviteButton = inviteButton
        }

        init(teamId: String,
             title: String,
             hexColorString: String,
             selected: Bool) {
            self.teamId = teamId
            self.title = title
            self.hexColorString = hexColorString
            self.selected = selected
        }

        func isContentEqual(to source: TeamHeader.Item) -> Bool {
            return teamId == source.teamId &&
                title == source.title &&
                hexColorString == source.hexColorString &&
                selected == source.selected
        }
    }

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
    //        func isContentEqual(to source: TeamHeader.Invitation) -> Bool {
    //            return teamId == source.teamId &&
    //                teamName == source.teamName &&
    //                teamColor == source.teamName &&
    //                sender == source.sender &&
    //                date == source.date &&
    //                memberCount == source.memberCount
    //        }
    //    }
}
