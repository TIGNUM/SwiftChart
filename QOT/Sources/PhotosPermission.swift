//
//  PhotosPermission.swift
//  QOT
//
//  Created by Lee Arromba on 30/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Photos

class PhotosPermission: PermissionInterface {
    func authorizationStatusDescription() -> PermissionsManager.AuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus().authorizationStatus
    }

    func askPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            completion(status == .authorized)
        }
    }
}

// MARK: - PHAuthorizationStatus

private extension PHAuthorizationStatus {
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
