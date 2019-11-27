//
//  PermissionsManager.swift
//  QOT
//
//  Created by Lee Arromba on 20/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

protocol PermissionManagerDelegate: class {
    func permissionManager(_ manager: PermissionsManager, didUpdatePermissions permissions: [PermissionsManager.Permission])
}

// there should only ever be 1 class instance
final class PermissionsManager {
    enum AuthorizationStatus: String {
        case granted
        case grantedWhileInForeground
        case denied
        case restricted
        case notDetermined
    }

    struct Permission {
        enum Identifier: String { // ensure each keys has a PermissionInterface
            case calendar
            case notifications
            case location
            case photos
            case camera
        }
        enum AskStatus {
            case canAsk
            case cantAsk
            case askLater
        }

        fileprivate let interface: PermissionInterface
        var askStatus: AskStatus
        var identifier: Identifier
    }
    private let calendarNotificationPermission = CalendarPermission()
    private let remoteNotificationPermission = RemoteNotificationPermission()
    private let locationPermission = LocationPermission()
    private let photosPermission = PhotosPermission()
    private let cameraPermission = CameraPermission()
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1 // only process 1 at a time (sequentially)
        return queue
    }()
    private var lastKnownAuthorizationStatusDescriptions = [Permission.Identifier: PermissionsManager.AuthorizationStatus]()
    private var data = [Permission.Identifier: Permission]()

    weak var delegate: PermissionManagerDelegate?
    var allPermissions: [Permission] {
        return data.values.map({ $0 })
    }

    init(delegate: PermissionManagerDelegate) {
        self.delegate = delegate
        reset()
        updateRemoteNotificationStatus()
    }

    func reset() {
        data = [ // ensure every key is mapped to a permission
            .calendar: Permission(interface: calendarNotificationPermission, askStatus: .canAsk, identifier: .notifications),
            .notifications: Permission(interface: remoteNotificationPermission, askStatus: .canAsk, identifier: .notifications),
            .location: Permission(interface: locationPermission, askStatus: .canAsk, identifier: .location),
            .photos: Permission(interface: photosPermission, askStatus: .canAsk, identifier: .photos),
            .camera: Permission(interface: cameraPermission, askStatus: .canAsk, identifier: .camera)
        ]
        lastKnownAuthorizationStatusDescriptions = fetchDescriptions()
    }

    func currentStatusFor(for permissionType: Permission.Identifier) -> PermissionsManager.AuthorizationStatus {
        return lastKnownAuthorizationStatusDescriptions[permissionType] ?? .notDetermined
    }

    func updateAskStatus(_ askStatus: Permission.AskStatus, for identifier: Permission.Identifier) {
        guard var permission = self.data[identifier] else { return }
        permission.askStatus = askStatus
        data[identifier] = permission
    }

    func askPermission(for identifier: Permission.Identifier,
                       completion: @escaping ([Permission.Identifier: AuthorizationStatus]) -> Void) {
        var results = [Permission.Identifier: AuthorizationStatus]()
        guard let permission = self.data[identifier] else { return }

        guard permission.askStatus == .canAsk else {
            results[identifier] = permission.askStatus == .askLater ? .restricted : .denied
            completion(results)
            return
        }

        permission.interface.askPermission(completion: { [weak self] granted in
            guard let strongSelf = self else { return }
            results[identifier] = granted ? .granted : .denied

            completion(results)
            if strongSelf.fetchHasUpdates() {
                strongSelf.delegate?.permissionManager(strongSelf, didUpdatePermissions: strongSelf.allPermissions)
            }
            strongSelf.reset()
        })
    }

    private func fetchHasUpdates() -> Bool {
        let hasUpdates = fetchDescriptions() != lastKnownAuthorizationStatusDescriptions
        return hasUpdates
    }

    private func fetchDescriptions() -> [Permission.Identifier: PermissionsManager.AuthorizationStatus] {
        var authorizationStatusDescriptions = [Permission.Identifier: PermissionsManager.AuthorizationStatus]()
        data.keys.forEach { key in
            guard let permission = self.data[key] else { return }
            authorizationStatusDescriptions[key] = permission.interface.authorizationStatusDescription()
        }

        return authorizationStatusDescriptions
    }

    private func updateRemoteNotificationStatus() {
        remoteNotificationPermission.refreshStatus(completion: { [weak self] in
            self?.reset()
        })
    }
}
