//
//  DailyBriefModel.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit

struct DailyBriefViewModel {

    enum Bucket: CaseIterable, Differentiable {
        case dailyCheckIn1
        case dailyCheckIn2
        case explore
        case whatsHotLatest
        case question
        case thoughts
        case goodToKnow
        case fromTignum
        case departureInfo
        case feastForYourEyes
        case impactReadiness
        case leaderswisdom
        case fromMyCoach
        case aboutMe
        case bespoke
        case thoughtsToPonder
        case meAtMyBest
        case getToLevel5
        case questionWithoutAnswer
        case guidedTrack
        case myPeakPerformance
        case solveReflection
    }
}
