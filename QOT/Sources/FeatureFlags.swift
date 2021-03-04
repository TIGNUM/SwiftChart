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

    let currentEnvironment = NetworkEnvironment().currentScheme

    func isFeatureActivated(feature: FeatureFlag, environment: NetworkEnvironment.Name) -> Bool {
        let dict = getActivatedFeatures()
        return ((dict[environment]?.contains(feature)) == true)
    }
}
