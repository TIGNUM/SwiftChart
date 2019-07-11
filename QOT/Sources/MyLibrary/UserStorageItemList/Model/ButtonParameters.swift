//
//  ButtonParameters.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct ButtonParameters {
    let title: String
    let target: Any
    let action: Selector
    let isEnabled: Bool

    init(title: String, target: Any, action: Selector, isEnabled: Bool = true) {
        self.title = title
        self.target = target
        self.action = action
        self.isEnabled = isEnabled
    }
}
