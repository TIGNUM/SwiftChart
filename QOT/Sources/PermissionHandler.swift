//
//  PermissionHandler.swift
//  QOT
//
//  Created by Lee Arromba on 20/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import EventKit
import UserNotifications
import CoreLocation
import Photos
import AVFoundation

final class PermissionHandler: NSObject {
    struct Result {
        var calendar = false
        var remoteNotification = false
        var location = false
        var photos = false
        var camera = false
        
        var isAllGranted: Bool {
            return calendar && remoteNotification && location && photos && camera
        }
    }
    
    private var locationPermissionCompletion: ((Bool) -> Void)?
    private let locationManager = CLLocationManager()
    private let queue = OperationQueue()
    
    var isEnabledForSession = true
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        queue.maxConcurrentOperationCount = 1
    }
    
    func askForAllPermissions(_ completion: @escaping (Result) -> Void) {
        var result = Result()
        queue.addOperation(WaitBlockOperation { [unowned self] (finish: (() -> Void)?) in
            self.askPermissionForCalendar(completion: { (granted: Bool) in
                result.calendar = granted
                finish?()
            })
        })
        queue.addOperation(WaitBlockOperation { [unowned self] (finish: (() -> Void)?) in
            self.askPermissionForRemoteNotifications(completion: { (granted: Bool) in
                result.remoteNotification = granted
                finish?()
            })
        })
        queue.addOperation(WaitBlockOperation { [unowned self] (finish: (() -> Void)?) in
            self.askPermissionForLocationAlways(completion: { (granted: Bool) in
                result.location = granted
                finish?()
            })
        })
        queue.addOperation(WaitBlockOperation { [unowned self] (finish: (() -> Void)?) in
            self.askPermissionForPhotos(completion: { (granted: Bool) in
                result.photos = granted
                finish?()
            })
        })
        queue.addOperation(WaitBlockOperation { [unowned self] (finish: (() -> Void)?) in
            self.askPermissionForCamera(completion: { (granted: Bool) in
                result.camera = granted
                completion(result)
                finish?()
            })
        })
    }
    
    func askPermissionForCalendar(completion: @escaping (Bool) -> Void) {
        guard isEnabledForSession else {
            completion(false)
            return
        }
        EKEventStore.shared.requestAccess(to: .event) { (granted: Bool, _: Error?) in
            completion(granted)
        }
    }
    
    func askPermissionForRemoteNotifications(completion: @escaping (Bool) -> Void) {
        guard isEnabledForSession else {
            completion(false)
            return
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { (granted: Bool, _: Error?) in
            completion(granted)
        }
    }
    
    func askPermissionForLocationAlways(completion: @escaping (Bool) -> Void) {
        let status = CLLocationManager.authorizationStatus()
        guard isEnabledForSession, status != .denied, status != .restricted else {
            completion(false)
            return
        }
        guard status != .authorizedAlways || status != .authorizedWhenInUse else {
            completion(true)
            return
        }
        
        locationPermissionCompletion = completion
        locationManager.requestAlwaysAuthorization()
    }
    
    func askPermissionForPhotos(completion: @escaping (Bool) -> Void) {
        guard isEnabledForSession else {
            completion(false)
            return
        }
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
            completion(true)
            return
        }
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                completion(true)
            case .restricted, .denied, .notDetermined:
                completion(false)
            }
        }
    }
    
    func askPermissionForCamera(completion: @escaping (Bool) -> Void) {
        guard isEnabledForSession else {
            completion(false)
            return
        }
        guard AVCaptureDevice.authorizationStatus(for: .video) != .authorized else {
            completion(true)
            return
        }
        AVCaptureDevice.requestAccess(for: .video) { (granted: Bool) in
            completion(granted)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension PermissionHandler: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationPermissionCompletion?(status == .authorizedAlways || status == .authorizedWhenInUse)
        locationPermissionCompletion = nil
    }
}
