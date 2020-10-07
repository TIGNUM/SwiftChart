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
                       trackerPoll: QDMTeamToBeVisionTrackerPoll?)
        case rating(visionPoll: QDMTeamToBeVisionPoll?,
                    trackerPoll: QDMTeamToBeVisionTrackerPoll?)

        func state() throws -> State {
            switch self {
            case .generator(let visionPoll, let trackerPoll):
                switch (trackerPoll?.open,
                        visionPoll?.creator,
                        visionPoll?.open,
                        visionPoll?.userDidVote) {
                case (true, false, _, _),
                     (_, false, false, _): return .isHidden

                case (_, false, true, true): return .isActive

                case (true, true, _, _): return .isInactive

                case (_, false, true, false),
                     (_, true, true, _): return .hasBatch

                default: throw StateError.unknown
                }
            case .rating(let visionPoll, let trackerPoll):
                switch (visionPoll?.open,
                        trackerPoll?.creator,
                        trackerPoll?.open,
                        trackerPoll?.didVote) {
                case (true, false, _, _),
                     (_, false, false, _): return .isHidden

                case (_, false, true, true): return .isActive

                case (true, true, _, _): return .isInactive

                case (_, false, true, false),
                     (_, true, true, _): return .hasBatch

                default: throw StateError.unknown
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
