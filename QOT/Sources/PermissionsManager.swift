//
//  PermissionsManager.swift
//  QOT
//
//  Created by Lee Arromba on 20/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import Freddy

protocol PermissionManagerDelegate: class {
    func permissionManager(_ manager: PermissionsManager, didUpdatePermissions permissions: [PermissionsManager.Permission])
}

// there should only ever be 1 class instance
final class PermissionsManager {
    enum AuthorizationStatus {
        case granted
        case denied
        case later
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

    private let remoteNotificationPermission = RemoteNotificationPermission()
    private let locationPermission = LocationPermission()
    private let photosPermission = PhotosPermission()
    private let cameraPermission = CameraPermission()
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1 // only process 1 at a time (sequentially)
        return queue
    }()
    private var lastKnownAuthorizationStatusDescriptions = [Permission.Identifier: String]()
    private var data = [Permission.Identifier: Permission]()

    weak var delegate: PermissionManagerDelegate?
    var allPermissions: [Permission] {
        return data.values.map({ $0 })
    }

    init(delegate: PermissionManagerDelegate) {
        self.delegate = delegate
        reset()
    }

    func reset() {
        data = [ // ensure every key is mapped to a permission
            .notifications: Permission(interface: remoteNotificationPermission, askStatus: .canAsk, identifier: .notifications),
            .location: Permission(interface: locationPermission, askStatus: .canAsk, identifier: .location),
            .photos: Permission(interface: photosPermission, askStatus: .canAsk, identifier: .photos),
            .camera: Permission(interface: cameraPermission, askStatus: .canAsk, identifier: .camera)
        ]
        fetchDescriptions { _ in }
    }

    func updateAskStatus(_ askStatus: Permission.AskStatus, for identifier: Permission.Identifier) {
        guard var permission = self.data[identifier] else { return }
        permission.askStatus = askStatus
        data[identifier] = permission
    }

    func askPermission(for identifiers: [Permission.Identifier],
                       completion: @escaping ([Permission.Identifier: AuthorizationStatus]) -> Void) {
        guard let lastIdentifier = identifiers.last else { return }
        var results = [Permission.Identifier: AuthorizationStatus]()
        identifiers.forEach { identifier in
            guard let permission = self.data[identifier] else { return }
            // add all the operations to the queue
            self.queue.addOperation(WaitBlockOperation { (finish: (() -> Void)?) in
                guard permission.askStatus == .canAsk else {
                    results[identifier] = permission.askStatus == .askLater ? .later : .denied
                    completion(results)
                    finish?()
                    return
                }
                // ask the permission. the permission's completion block won't be fired until the user responds
                permission.interface.askPermission(completion: { granted in
                    results[identifier] = granted ? .granted : .denied
                    // fire user's completion block if it's the last permission
                    if identifier == lastIdentifier {
                        DispatchQueue.main.async {
                            completion(results)
                            self.fetchHasUpdates { hasUpdates in
                                if hasUpdates {
                                    self.delegate?.permissionManager(self, didUpdatePermissions: self.allPermissions)
                                }
                                finish?() // finish the operation
                            }
                        }
                    } else {
                        finish?() // finish the operation
                    }
                })
            })
        }
    }

    func fetchHasUpdates(completion: @escaping (Bool) -> Void) {
        fetchDescriptions { descriptions in
            let hasUpdates = descriptions != self.lastKnownAuthorizationStatusDescriptions
            completion(hasUpdates)
        }
    }

    func serializedJSONData(for: [Permission], completion: @escaping (Data?) -> Void) {
        fetchDescriptions { descriptions in
            var json = [JSON]()
            descriptions.keys.forEach { key in
                guard let value = descriptions[key] else { return }
                let data: [JsonKey: JSONEncodable] = [
                    .feature: key.rawValue,
                    .permissionState: value
                ]
                json.append(.dictionary(data.mapKeyValues({ ($0.rawValue, $1.toJSON()) })))
            }
            completion(try? json.toJSON().serialize())
        }
    }

    // MARK: - private
    private func fetchDescriptions(completion: @escaping ([Permission.Identifier: String]) -> Void) {
        var authorizationStatusDescriptions = [Permission.Identifier: String]()
        let group = DispatchGroup()

        self.data.keys.forEach { key in
            group.enter()
            guard let permission = self.data[key] else { return }
            permission.interface.authorizationStatusDescription(completion: { description in
                authorizationStatusDescriptions[key] = description
                group.leave()
            })
        }

        group.notify(queue: .main) {
            completion(authorizationStatusDescriptions)
            self.lastKnownAuthorizationStatusDescriptions = authorizationStatusDescriptions // must be after completion block for fetchHasUpdates(_) logic to work
        }
    }
}
