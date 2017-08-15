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
        BubbleLayoutInfo(radius: 0.156771799628942, centerX: 0.485157699443414, centerY: 0.481447124304267),
        BubbleLayoutInfo(radius: 0.150278293135436, centerX: 0.315398886827458, centerY: 0.196660482374768),
        BubbleLayoutInfo(radius: 0.141929499072356, centerX: 0.175324675324675, centerY: 0.568645640074211),
        BubbleLayoutInfo(radius: 0.146567717996289, centerX: 0.452690166975881, centerY: 0.812615955473098),
        BubbleLayoutInfo(radius: 0.125231910946197, centerX: 0.778293135435993, centerY: 0.61317254174397),
        BubbleLayoutInfo(radius: 0.156771799628942, centerX: 0.722634508348794, centerY: 0.212430426716141)
    ]

    func bubbleLayoutInfo(at index: Index) -> BubbleLayoutInfo {
        return defaultBubbles.count > index ? defaultBubbles[index] : BubbleLayoutInfo()
    }
}
