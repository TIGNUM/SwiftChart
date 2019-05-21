//
//  AppDelegate+Siren.swift
//  QOT
//
//  Created by karmic on 08.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

// MARK: - Siren. App Store version check.

enum SirenMessagingType: String {
    case titleForced = "alert.title.release.manager.forced"
    case messageForced = "alert.message.release.manager.forced"
    case buttonUpdateForced = "alert.button.title.release.manager.update"
    case titleOptional = "alert.title.release.manager.optional"
    case messageOptional = "alert.message.release.manager.optional"
    case buttonUpdateOptional = "alert.button.title.release.manager.skip"
    case buttonNexTimeOptional = "alert.button.title.release.manager.update.optional"

    func value(contentServie: ContentService?) -> String? {
        return contentServie?.releaseManagerValue(for: self)
    }
}
