//
//  LearnCategoryListPage.swift
//  QOT
//
//  Created by Sam Wyndham on 19.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

struct LearnCategoryListPage {

    private let defaultBubbles = [
        BubbleLayoutInfo(radius: 0.15, centerX: 0.5, centerY: 0.5),
        BubbleLayoutInfo(radius: 0.131, centerX: 0.32, centerY: 0.24),
        BubbleLayoutInfo(radius: 0.125, centerX: 0.186, centerY: 0.558),
        BubbleLayoutInfo(radius: 0.131, centerX: 0.442, centerY: 0.804),
        BubbleLayoutInfo(radius: 0.111, centerX: 0.788, centerY: 0.585),
        BubbleLayoutInfo(radius: 0.139, centerX: 0.716, centerY: 0.250)
    ]

    func bubbleLayoutInfo(at index: Index) -> BubbleLayoutInfo {
        return defaultBubbles.count > index ? defaultBubbles[index] : BubbleLayoutInfo()
    }
}
