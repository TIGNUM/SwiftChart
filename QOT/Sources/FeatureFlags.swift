//
//  FeatureFlags.swift
//  QOT
//
//  Created by Anais Plancoulaine on 04.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class FeatureFlags {

    enum FeatureFlag {
        case customizableNotifications
    }

    private func getActivatedFeatures() -> [NetworkEnvironment.Name: [FeatureFlag]] {
        return [.DEV: [.customizableNotifications],
                .INT: [.customizableNotifications],
                .PUB: []]
    }

    func isFeatureActivated(feature: FeatureFlag, environment: NetworkEnvironment.Name) -> Bool {
        let dict = getActivatedFeatures()
        return ((dict[environment]?.contains(feature)) == true)
    }
}

struct Feature {
    enum Flag {
        case editableNotifications

        private var activated: [NetworkEnvironment.Name: [Feature.Flag]] {
            return [.DEV: [.editableNotifications],
                    .INT: [.editableNotifications],
                    .PUB: []]
        }

        func isOn(for environment: NetworkEnvironment.Name) -> Bool {
            return activated[environment]?.contains(self) == true
        }
    }
}
