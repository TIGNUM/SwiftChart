//
//  AppDelegate+Siren.swift
//  QOT
//
//  Created by karmic on 08.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import Siren

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

extension AppDelegate {

    func setupSiren(services: Services?) {
        guard let minVersion = services?.settingsService.releaseManagerMinimalVersion else { return }
        if Bundle.main.versionNumber < minVersion {
            let forcedSiren = Siren.shared
            forcedSiren.alertType = .force
            forcedSiren.checkVersion(checkType: .immediately)
            guard
                let title = SirenMessagingType.titleForced.value(contentServie: services?.contentService),
                let message = SirenMessagingType.messageForced.value(contentServie: services?.contentService),
                let button = SirenMessagingType.buttonUpdateForced.value(contentServie: services?.contentService) else { return }
            forcedSiren.alertMessaging = SirenAlertMessaging(updateTitle: title,
                                                             updateMessage: message,
                                                             updateButtonMessage: button)
        } else {
            let sirenOptional = Siren.shared
            sirenOptional.alertType = .option
            sirenOptional.checkVersion(checkType: .daily)
            guard
                let title = SirenMessagingType.titleOptional.value(contentServie: services?.contentService),
                let message = SirenMessagingType.messageOptional.value(contentServie: services?.contentService),
                let buttonUpdate = SirenMessagingType.buttonUpdateOptional.value(contentServie: services?.contentService),
                let buttonLater = SirenMessagingType.buttonNexTimeOptional.value(contentServie: services?.contentService) else { return }
            sirenOptional.alertMessaging = SirenAlertMessaging(updateTitle: title,
                                                               updateMessage: message,
                                                               updateButtonMessage: buttonLater,
                                                               nextTimeButtonMessage: buttonUpdate)
        }
    }
}
