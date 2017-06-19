//
//  LearnContentCategory.swift
//  QOT
//
//  Created by Sam Wyndham on 31/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

/// Encapsulates data to display in a `LearnCategoryListViewController`.
protocol LearnContentCategory: TrackableEntity {
    var localID: String { get }
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

    var learnContent: DataProvider<LearnContentCollection> { get }

    var bubbleLayoutInfo: BubbleLayoutInfo { get }

    var remoteID: Int { get }
}

extension ContentCategory: LearnContentCategory {

    /// Returns a `Double` between 0 and 1 representing the cells radius.
    var radius: Double {
        return bubbleLayoutInfo.radius
    }

    var localID: String {
        return String(Int.randomID)
    }

    var itemCount: Int {
        return contentCollections.count
    }

    var viewedCount: Int {
        return contentCollections.filter { $0.viewed }.count
    }

    var percentageLearned: Double {
        let total = contentCollections.reduce(0) { $0.0 + $0.1.percentageViewed }
        return total / Double(contentCollections.count)
    }

    var center: CGPoint {
        return CGPoint(x: bubbleLayoutInfo.centerX, y: bubbleLayoutInfo.centerY)
    }

    var learnContent: DataProvider<LearnContentCollection> {
        return DataProvider(items: contentCollections, map: { $0 as LearnContentCollection })
    }

    var trackableEntityID: Int {
        return Int.randomID
    }
}
