//
//  APNSDeviceTokenRegistrator.swift
//  QOT
//
//  Created by Sam Wyndham on 13.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Airship
import qot_dal

final class APNSDeviceTokenRegistrator {
    private var token: String?
    private let becomeActiveHandler = NotificationHandler(name: UIApplication.didBecomeActiveNotification)

    init() {
        becomeActiveHandler.handler = { [unowned self] _ in
            self.uploadToken()
        }
    }

    func registerDeviceToken(_ token: String) {
        self.token = token
        uploadToken()
    }

    private func uploadToken() {
        guard let token = token else { return }
        let appKey = UAConfig.default().appKey
        let qotService = QOTService.main
        #if DEBUG
        qotService.reportDeviceToken(token, appKey: appKey, inProduction: false)
        #else
        qotService.reportDeviceToken(token, appKey: appKey, inProduction: true)
        #endif
    }
}
