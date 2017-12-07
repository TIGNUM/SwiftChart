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
        completion(AVCaptureDevice.authorizationStatus(for: .video).stringValue)
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
