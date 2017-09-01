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
        BubbleLayoutInfo(radius: 0.160771799628942, centerX: 0.485157699443414, centerY: 0.481447124304267),
        BubbleLayoutInfo(radius: 0.160278293135436, centerX: 0.305398886827458, centerY: 0.186660482374768),
        BubbleLayoutInfo(radius: 0.152929499072356, centerX: 0.165324675324675, centerY: 0.558645640074211),
        BubbleLayoutInfo(radius: 0.158567717996289, centerX: 0.452690166975881, centerY: 0.812615955473098),
        BubbleLayoutInfo(radius: 0.153929499072356, centerX: 0.789293135435993, centerY: 0.60317254174397),
        BubbleLayoutInfo(radius: 0.166771799628942, centerX: 0.692634508348794, centerY: 0.202430426716141)
    ]

    func bubbleLayoutInfo(at index: Index) -> BubbleLayoutInfo {
        return defaultBubbles.count > index ? defaultBubbles[index] : BubbleLayoutInfo()
    }
}
