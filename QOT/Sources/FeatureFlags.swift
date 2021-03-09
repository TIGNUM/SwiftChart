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

        var activated: [NetworkEnvironment.Name: [Feature.Flag]] {
            return [.DEV: [.editableNotifications],
                    .INT: [.editableNotifications],
                    .PUB: []]
        }

        func isOn(_ activated: [NetworkEnvironment.Name: [Feature.Flag]],
                  environment: NetworkEnvironment.Name) -> Bool {
            return activated[environment]?.contains(self) == true
        }
    }
}
