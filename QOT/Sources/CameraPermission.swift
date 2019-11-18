//
//  CameraPermission.swift
//  QOT
//
//  Created by Lee Arromba on 30/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import AVFoundation

class CameraPermission: PermissionInterface {
    func authorizationStatusDescription() -> PermissionsManager.AuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video).authorizationStatus
    }

    func askPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            completion(granted)
        }
    }
}

// MARK: - AVAuthorizationStatus

private extension AVAuthorizationStatus {
    var authorizationStatus: PermissionsManager.AuthorizationStatus {
        switch self {
        case .notDetermined:
            return PermissionsManager.AuthorizationStatus.notDetermined
        case .denied:
            return PermissionsManager.AuthorizationStatus.denied
        case .restricted:
            return PermissionsManager.AuthorizationStatus.restricted
        case .authorized:
            return PermissionsManager.AuthorizationStatus.granted
        }
    }
}
