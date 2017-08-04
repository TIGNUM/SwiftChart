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

class PermissionHandler: NSObject {
    struct Result {
        var calendar: Bool
        var remoteNotification: Bool
        var location: Bool
        
        var isAllGranted: Bool {
            return calendar && remoteNotification && location
        }
    }
    
    fileprivate var locationPermissionCompletion: ((Bool) -> Void)?
    private let locationManager = CLLocationManager()
    private let queue = OperationQueue()
    
    var isEnabledForSession = true
    
    override init() {
        super.init()
        locationManager.delegate = self
        queue.maxConcurrentOperationCount = 1
    }
    
    func askForAllPermissions(_ completion: @escaping (Result) -> Void) {
        var result = Result(calendar: false, remoteNotification: false, location: false)
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
            self.askPermissionForLocation(completion: { (granted: Bool) in
                result.location = granted
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
    
    func askPermissionForLocation(completion: @escaping (Bool) -> Void) {
        guard isEnabledForSession else {
            completion(false)
            return
        }
        guard CLLocationManager.authorizationStatus() != .authorizedWhenInUse else {
            completion(true)
            return
        }
        locationPermissionCompletion = completion
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate

extension PermissionHandler: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationPermissionCompletion?(status == .authorizedWhenInUse)
        locationPermissionCompletion = nil
    }
}
