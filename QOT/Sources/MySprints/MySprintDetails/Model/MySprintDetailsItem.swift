//
//  MySprintDetailsItem.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 25/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct MySprintDetailsItem {
    enum ItemType {
        case header(action: Action?)
        case listItem(appearance: Appearance)
        case ctaItem(action: Action)
    }
    enum Appearance {
        case info
        case regular
        case active
    }
    // Start from '1' to differentiate from the default button tag ('0')
    enum Action: Int {
        case captureTakeaways = 1
        case highlights
        case strategies
        case benefits
    }

    let type: ItemType
    let text: String
}
