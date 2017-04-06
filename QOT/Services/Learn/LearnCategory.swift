//
//  LearnCategory.swift
//  QOT
//
//  Created by Sam Wyndham on 31/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import QOTDatabase

/// Encapsulates data to display in a `LearnCategoryListViewController`.
protocol LearnCategory: TrackableEntity {
    var id: Int { get }
    /// The title of `self`.
    var title: String { get }
    /// The number of items that belong `self`.
    var itemCount: Int { get }
    /// The number of items that belong `self` and have been viewed.
    var viewedCount: Int { get }
    /// Returns a `Double` between 0 and 1 how much of the contents have been learned. This is an expensive operation.
    var percentageLearned: Double { get }
    /// Returns a `Double` between 0 and 1 representing the cells radius.
    var radius: Double { get }
    /// Returns the cell's center.
    var center: CGPoint { get }

    var learnContent: DataProvider<LearnContent> { get }
}

extension ContentCategory: LearnCategory {
    var itemCount: Int {
        return contents.count
    }

    var viewedCount: Int {
        return contents.filter { $0.viewed }.count
    }

    var percentageLearned: Double {
        let total = contents.reduce(0) { $0.0 + $0.1.percentageViewed }
        return total / Double(contents.count)
    }

    var center: CGPoint {
        return CGPoint(x: centerX, y: centerY)
    }

    var learnContent: DataProvider<LearnContent> {
        return DataProvider(list: contents, map: { $0 as LearnContent })
    }

    var trackableEntityID: Int {
        return id
    }
}
