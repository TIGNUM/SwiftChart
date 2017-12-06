//
//  PhotosPermission.swift
//  QOT
//
//  Created by Lee Arromba on 30/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Photos

struct PhotosPermission: PermissionInterface {
    func authorizationStatusDescription(completion: @escaping (String) -> Void) {
        completion(PHPhotoLibrary.authorizationStatus().stringValue)
    }

    func askPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            completion(status == .authorized)
        }
    }
}

// MARK: - PHAuthorizationStatus

private extension PHAuthorizationStatus {
    var stringValue: String {
        switch self {
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorized:
            return "authorized"
        }
    }
}
