//
//  APNSDeviceTokenRegistrar.swift
//  QOT
//
//  Created by Sam Wyndham on 13.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Alamofire

final class APNSDeviceTokenRegistrar {

    private let timerDelay: TimeInterval = 60
    private let networkManager: NetworkManager
    private var token: String?
    private var timer: Timer?
    private let credentialsManager: CredentialsManager
    private let becomeActiveHandler = NotificationHandler(name: .UIApplicationDidBecomeActive)
    private let resignActiveHandler = NotificationHandler(name: .UIApplicationWillResignActive)

    init(networkManager: NetworkManager, credentialsManager: CredentialsManager) {
        self.networkManager = networkManager
        self.credentialsManager = credentialsManager

        becomeActiveHandler.handler = { [unowned self] _ in
            self.uploadToken()
        }
        resignActiveHandler.handler = { [unowned self] _ in
            self.timer?.invalidate()
        }
        credentialsManager.onCredentialChange { [weak self] (credential: Credential?) in
            if credential != nil {
                self?.uploadToken()
            }
        }
    }

    func registerDeviceToken(_ token: String) {
        self.token = token
        uploadToken()
    }

    deinit {
        timer?.invalidate()
    }

    private func uploadToken() {
        guard let token = token, credentialsManager.credential != nil else {
            return
        }
        networkManager.performAPNSDeviceTokenRequest(token: token) { [weak self] (error) in
            if let error = error {
                self?.scheduleUpload()
                log("Failed to upload APNS Token: \(token), error: \(error)")
            } else {
                self?.didUploadToken(token)
                log("Did upload APNS Token: \(token)")
            }
        }
    }

    private func scheduleUpload() {
        timer = Timer.scheduledTimer(withTimeInterval: timerDelay, repeats: false) { [weak self] (_) in
            self?.uploadToken()
        }
    }

    private func didUploadToken(_ token: String) {
        if self.token == token {
            self.token = nil
        }
    }
}
