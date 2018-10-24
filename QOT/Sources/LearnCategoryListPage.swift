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
        BubbleLayoutInfo(radius: 0.166771799628942, centerX: 0.485157699443414, centerY: 0.481447124304267),    // mindset
        BubbleLayoutInfo(radius: 0.166771799628942, centerX: 0.305398886827458, centerY: 0.186660482374768),    // nutrition
        BubbleLayoutInfo(radius: 0.166771799628942, centerX: 0.145324675324675, centerY: 0.558645640074211),    // movement
        BubbleLayoutInfo(radius: 0.166771799628942, centerX: 0.452690166975881, centerY: 0.822615955473098),    // recovery
        BubbleLayoutInfo(radius: 0.166771799628942, centerX: 0.810293135435993, centerY: 0.61317254174397),     // habituation
        BubbleLayoutInfo(radius: 0.166771799628942, centerX: 0.692634508348794, centerY: 0.202430426716141)     // foundation
    ]

    func bubbleLayoutInfo(at index: Index) -> BubbleLayoutInfo {
        return defaultBubbles.count > index ? defaultBubbles[index] : BubbleLayoutInfo()
    }
}
