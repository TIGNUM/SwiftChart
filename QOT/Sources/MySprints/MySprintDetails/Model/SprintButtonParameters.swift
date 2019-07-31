//
//  SprintButtonParameters.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 25/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct SprintButtonParameters {
    let title: String
    let icon: UIImage?
    let target: Any
    let action: Selector

    init(title: String, icon: UIImage? = nil, target: Any, action: Selector) {
        self.title = title
        self.icon = icon
        self.target = target
        self.action = action
    }
}
