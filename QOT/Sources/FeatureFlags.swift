//
//  FeatureFlags.swift
//  QOT
//
//  Created by Anais Plancoulaine on 04.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct Feature {
    enum Flag {
        case editableNotifications

        private var activated: [Environment.Name: [Feature.Flag]] {
            return [.DEV: [.editableNotifications],
                    .INT: [.editableNotifications],
                    .PUB: []]
        }

        var isOn: Bool {
            return activated[Environment().current]?.contains(self) == true
        }
    }
}
