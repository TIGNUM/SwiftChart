//
//  APNSDeviceTokenRegistrar.swift
//  QOT
//
//  Created by Sam Wyndham on 13.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import AirshipKit
import qot_dal

final class APNSDeviceTokenRegistrar {

    private let timerDelay: TimeInterval = 60
    private var token: String?
    private let becomeActiveHandler = NotificationHandler(name: .UIApplicationDidBecomeActive)

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
