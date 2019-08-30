//
//  WalkthroughWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughWorker {

    // MARK: - Properties
    let selectedTrack: SelectedTrackType

    // MARK: - Init

    init(selectedTrack: SelectedTrackType) {
        self.selectedTrack = selectedTrack
    }

    func saveViewedWalkthrough() {
        UserDefault.didShowCoachMarks.setBoolValue(value: true)
    }
}
