//
//  LearnContent.swift
//  QOT
//
//  Created by Sam Wyndham on 31/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

/// Encapsulates data to display in a `LearnContentListViewController`.
protocol LearnContent: TrackableEntity {
    /// The title of the content.
    var title: String { get }
    /// Whether the content has been viewed.
    var viewed: Bool { get }
    /// Time required in minutes to view the content.
    var minutesRequired: Int { get }
}

extension Content: LearnContent {
    var viewed: Bool {
        return percentageViewed > 0
    }

    var minutesRequired: Int {
        return items.reduce(0, { $0.0 + $0.1.secondsRequired }) / 60
    }

    var trackableEntityID: Int {
        return id
    }
}
