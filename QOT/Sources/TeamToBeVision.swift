//
//  TeamToBeVision.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct TeamTBV {
    enum StateError: Error {
        case unknown
    }

    enum CTA {
        case generator(visionPoll: QDMTeamToBeVisionPoll?,
                       trackerPoll: QDMTeamToBeVisionTrackerPoll?,
                       team: QDMTeam?)
        case rating(visionPoll: QDMTeamToBeVisionPoll?,
                    trackerPoll: QDMTeamToBeVisionTrackerPoll?,
                    team: QDMTeam?)

        func state() throws -> State {
            switch self {
            case .generator(let visionPoll, let trackerPoll, let team):
                log("🎯🎯🎯 Generator: trackerPoll?.open == true: \(trackerPoll?.open == true)", level: .debug)
                log("🎯🎯🎯 Generator: visionPoll?.creator == true: \(visionPoll?.creator == true)", level: .debug)
                log("🎯🎯🎯 Generator: visionPoll?.open == true: \(visionPoll?.open == true)", level: .debug)
                log("🎯🎯🎯 Generator: visionPoll?.userDidVote == true: \(visionPoll?.userDidVote == true)", level: .debug)
                log("🎯🎯🎯 Generator: team?.thisUserIsOwner == true: \(team?.thisUserIsOwner == true)", level: .debug)
                switch (trackerPoll?.open == true,
                        visionPoll?.creator == true,
                        visionPoll?.open == true,
                        visionPoll?.userDidVote == true,
                        team?.thisUserIsOwner == true) {
                case (false, false, false, false, false),
                     (true, false, _, _, false),
                     (_, false, false, _, false):
                    log("🎯🎯🎯 Generator.State: .isHidden", level: .debug)
                    return .isHidden

                case (_, false, true, true, _),
                     (false, false, false, false, true):
                    log("🎯🎯🎯 Generator.State: .isActive", level: .debug)
                    return .isActive

                case (true, true, _, _, true):
                    log("🎯🎯🎯 Generator.State: .isInactive", level: .debug)
                    return .isInactive

                case (_, false, true, false, _),
                     (_, true, true, _, _):
                    log("🎯🎯🎯 Generator.State: .hasBatch", level: .debug)
                    return .hasBatch

                default:
                    log("🎯🎯🎯 Generator.State: StateError.unknown", level: .debug)
                    throw StateError.unknown
                }
            case .rating(let visionPoll, let trackerPoll, let team):
                log("🎱🎱🎱 Tracker: visionPoll?.open == true: \(visionPoll?.open == true)", level: .debug)
                log("🎱🎱🎱 Tracker: trackerPoll?.creator == true: \(trackerPoll?.creator == true)", level: .debug)
                log("🎱🎱🎱 Tracker: trackerPoll?.open == true: \(trackerPoll?.open == true)", level: .debug)
                log("🎱🎱🎱 Tracker: trackerPoll?.didVote == true: \(trackerPoll?.didVote == true)", level: .debug)
                log("🎱🎱🎱 Tracker: team?.thisUserIsOwner == true: \(team?.thisUserIsOwner == true)", level: .debug)
                switch (visionPoll?.open == true,
                        trackerPoll?.creator == true,
                        trackerPoll?.open == true,
                        trackerPoll?.didVote == true,
                        team?.thisUserIsOwner == true) {
                case (false, false, false, false, false),
                     (true, false, _, _, false),
                     (_, false, false, _, false):
                    log("🎱🎱🎱 Tracker.State: .isHidden", level: .debug)
                    return .isHidden

                case (_, false, true, true, _),
                     (false, false, false, false, true):
                    log("🎱🎱🎱 Tracker.State: .isActive", level: .debug)
                    return .isActive

                case (true, _, _, _, true):
                    log("🎱🎱🎱 Tracker.State: .isInactive", level: .debug)
                    return .isInactive

                case (_, false, true, false, _),
                     (_, true, true, _, _):
                    log("🎱🎱🎱 Tracker.State: .hasBatch", level: .debug)
                    return .hasBatch

                default:
                    log("🎱🎱🎱 Tracker.State: .StateError.unknown", level: .debug)
                    throw StateError.unknown
                }
            }
        }

        enum State {
            case isHidden
            case isActive
            case isInactive
            case hasBatch
        }
    }
}
