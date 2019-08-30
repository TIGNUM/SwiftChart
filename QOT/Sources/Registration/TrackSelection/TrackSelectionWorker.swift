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
        return R.string.localized.onboardingRegistrationTrackSelectionTitle();
    }()

    lazy var descriptionText: String = {
        return R.string.localized.onboardingRegistrationTrackSelectionMessage()
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
