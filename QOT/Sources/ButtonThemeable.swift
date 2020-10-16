//
//  ButtonThemeable.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 07/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct ButtonTheme {
    let foregroundColor: UIColor
    let backgroundColor: UIColor?
    let borderColor: UIColor?

    init(foreground: UIColor, background: UIColor? = nil, border: UIColor? = nil) {
        foregroundColor = foreground
        backgroundColor = background
        borderColor = border
    }
}

extension ButtonTheme {
    enum State {
        case isHidden
        case isActive
        case isInactive
        case hasBatch
        case undefined

        enum StateError: Error {
            case unknown
        }
    }

    enum Action {
        case showBanner(message: String)
        case showAdminOptionsGenerator
        case showAdminOptionsRating
        case showIntroGenerator
        case showIntroRating
        case showGenerator
        case showRating
        case undefined
    }

    enum Poll {
        case generator(visionPoll: QDMTeamToBeVisionPoll?,
                       trackerPoll: QDMTeamToBeVisionTrackerPoll?,
                       team: QDMTeam?,
                       tbv: QDMTeamToBeVision?)
        case rating(visionPoll: QDMTeamToBeVisionPoll?,
                    trackerPoll: QDMTeamToBeVisionTrackerPoll?,
                    team: QDMTeam?,
                    tbv: QDMTeamToBeVision?)

        func stateWithAction() throws -> (state: State, action: Action) {
            switch self {
            case .generator(let visionPoll, let trackerPoll, let team, let tbv):
                log("🎯🎯🎯 Generator: trackerPoll?.open == \(trackerPoll?.open == true)", level: .debug)
                log("🎯🎯🎯 Generator: visionPoll?.open == \(visionPoll?.open == true)", level: .debug)
                log("🎯🎯🎯 Generator: visionPoll?.userDidVote == \(visionPoll?.userDidVote == true)", level: .debug)
                log("🎯🎯🎯 Generator: team?.thisUserIsOwner == \(team?.thisUserIsOwner == true)", level: .debug)
                log("🎯🎯🎯 Generator: teamTBV != nil: \(tbv != nil)", level: .debug)

                switch (trackerPoll?.open == true,
                        visionPoll?.open == true,
                        visionPoll?.userDidVote == true,
                        team?.thisUserIsOwner == true) {
                case (false, false, false, false),
                     (true, _, _, false):
                    log("🎯🎯🎯 Generator.State: .isHidden", level: .debug)
                    return (state: .isHidden, action: .undefined)

                case (false, false, _, true):
                    log("🎯🎯🎯 Generator.State: .isActive, action: ", level: .debug)
                    return (state: .isActive, action: .showIntroGenerator)

                case (_, _, true, false),
                     (true, false, false, true):
                    log("🎯🎯🎯 Generator.State: .isInactive, action: .showBanner", level: .debug)
                    let message = AppTextService.get(.banner_unavailable_while_poll_active)
                    return (state: .isInactive, action: .showBanner(message: message))

                case (false, true, false, false):
                    log("🎯🎯🎯 Generator.State: .hasBatch, action: .showIntro", level: .debug)
                    return (state: .hasBatch, action: .showIntroGenerator)

                case (false, true, _, true):
                    log("🎯🎯🎯 Generator.State: .hasBatch, action: .showAdminOptionsGenerator", level: .debug)
                    return (state: .hasBatch, action: .showAdminOptionsGenerator)

                default:
                    log("🎯🎯🎯 Generator.State: StateError.unknown", level: .debug)
                    throw State.StateError.unknown
                }
            case .rating(let visionPoll, let trackerPoll, let team, let tbv):
                log("🎱🎱🎱 Tracker: visionPoll?.open == \(visionPoll?.open == true)", level: .debug)
                log("🎱🎱🎱 Tracker: trackerPoll?.open == \(trackerPoll?.open == true)", level: .debug)
                log("🎱🎱🎱 Tracker: trackerPoll?.didVote == \(trackerPoll?.didVote == true)", level: .debug)
                log("🎱🎱🎱 Tracker: team?.thisUserIsOwner == \(team?.thisUserIsOwner == true)", level: .debug)
                log("🎱🎱🎱 Tracker: teamTBV != nil: \(tbv != nil)", level: .debug)
                switch (visionPoll?.open == true,
                        trackerPoll?.open == true,
                        trackerPoll?.didVote == true,
                        team?.thisUserIsOwner == true) {
                case (false, false, false, false),
                     (true, _, _, false):
                    log("🎱🎱🎱 Tracker.State: .isHidden", level: .debug)
                    return (state: .isHidden, action: .undefined)

                case (false, false, _, true):
                    log("🎱🎱🎱 Tracker.State: .isActive, action: .showIntro", level: .debug)
                    return (state: .isActive, action: .showIntroRating)

                case (true, false, false, true):
                    log("🎱🎱🎱 Tracker.State: .isInactive, action: .showBanner", level: .debug)
                    let message = AppTextService.get(.banner_unavailable_while_poll_active)
                    return (state: .isInactive, action: .showBanner(message: message))

                case (_, _, true, false):
                    log("🎱🎱🎱 Tracker.State: .isInactive, action: .showBanner", level: .debug)
                    let message = AppTextService.get(.banner_unavailable_while_poll_active)
                    return (state: .isInactive, action: .showBanner(message: message))

                case (false, true, false, false):
                    log("🎱🎱🎱 Tracker.State: .hasBatch, action: .showIntro", level: .debug)
                    return (state: .hasBatch, action: .showIntroRating)

                case (false, true, _, true):
                    log("🎱🎱🎱 Tracker.State: .hasBatch, action: .showAdminOptionsRating", level: .debug)
                    return (state: .hasBatch, action: .showAdminOptionsRating)

                default:
                    log("🎱🎱🎱 Tracker.State: StateError.unknown", level: .debug)
                    throw State.StateError.unknown
                }
            }
        }
    }
}

protocol ButtonThemeable {
    var titleAttributes: [NSAttributedString.Key: Any]? { get set }
    var normal: ButtonTheme? { get set }
    var highlight: ButtonTheme? { get set }
    var select: ButtonTheme? { get set }
    var disabled: ButtonTheme? { get set }
    var ctaState: ButtonTheme.State? { get set }
    var ctaAction: ButtonTheme.Action? { get set }

    func setTitle(_ title: String?)
    func setAttributedTitle(_ title: NSAttributedString?)
}

extension ButtonThemeable {
    func setAttributedTitle(_ title: NSAttributedString?) {
        // nop - making the method optional
    }
}
