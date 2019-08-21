//
//  TrackSelectionWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class TrackSelectionWorker {

    // MARK: - Properties

    lazy var title: String = {
        return "YOUR ACCOUNT IS CREATED"
    }()

    lazy var descriptionText: String = {
        return """
            Since QOT is quite rich in content and use cases we created two options for you to start:

            1. Fast Track - this will lead you write into QOT so that you can explore it yourself.

            2. Guided Track - we created a roadmap for you with recommended step."
            """
    }()

    lazy var fastTrackButton: String = {
        return R.string.localized.onboardingRegistrationTrackSelectionButtonFastTrack()
    }()

    lazy var guidedTrackButton: String = {
        return R.string.localized.onboardingRegistrationTrackSelectionButtonGuidedTrack()
    }()

    // MARK: - Init

    init() {
    }
}
