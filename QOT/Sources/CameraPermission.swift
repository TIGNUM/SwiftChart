//
//  CameraPermission.swift
//  QOT
//
//  Created by Lee Arromba on 30/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import AVFoundation

struct CameraPermission: PermissionInterface {
    func authorizationStatusDescription(completion: @escaping (String) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            completion("notDetermined")
        case .restricted:
            completion("restricted")
        case .denied:
            completion("denied")
        default:
            completion("authorized")
        }
    }

    func askPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            completion(granted)
        }
    }
}

// MARK: - AVAuthorizationStatus

private extension AVAuthorizationStatus {
    var stringValue: String {
        switch self {
        case .notDetermined:
            return "notDetermined"
        case .denied:
            return "denied"
        case .restricted:
            return "restricted"
        case .authorized:
            return "authorized"
        }
    }
}
