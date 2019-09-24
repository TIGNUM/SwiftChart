//
//  WeatherViewModel.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 11/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

enum LocationPermissionStatus {
    case allowed
    case notSet
    case denied
}

enum WeatherType: String {
    case clearSky = "Clear sky"
    case cloudy = "Cloudy"
    case rain = "Rain"
    case thunderStorm = "Thunderstorm"
    case snow = "Snow"
    case mist = "Mist"
}

final class WeatherViewModel: BaseDailyBriefViewModel {

    // MARK: - Properties
    var bucketTitle: String?
    var intro: String?
    var requestLocationPermissionDescription: String?
    var requestLocationPermissionButtonTitle: String?
    var deniedLocationPermissionDescription: String?
    var deniedLocationPermissionButtonTitle: String?
    var locationPermissionStatus: LocationPermissionStatus = .notSet
    private var locationPermission = LocationPermission()

    // MARK: - Init
    internal init(bucketTitle: String = "",
                  intro: String?,
                  requestLocationPermissionDescription: String?,
                  requestLocationPermissionButtonTitle: String?,
                  deniedLocationPermissionDescription: String?,
                  deniedLocationPermissionButtonTitle: String?,
                  domain: QDMDailyBriefBucket?) {
        self.bucketTitle = bucketTitle
        self.intro = intro
        self.requestLocationPermissionDescription = requestLocationPermissionDescription
        self.requestLocationPermissionButtonTitle = requestLocationPermissionButtonTitle
        self.deniedLocationPermissionDescription = deniedLocationPermissionDescription
        self.deniedLocationPermissionButtonTitle = deniedLocationPermissionButtonTitle
        super.init(domain)
        self.updateLocationPermissionStatus { (_) in}
    }

    override func isContentEqual(to source: BaseDailyBriefViewModel) -> Bool {
        guard let source = source as? WeatherViewModel else {
            return false
        }
        return super.isContentEqual(to: source) &&
            bucketTitle == source.bucketTitle &&
            intro == source.intro &&
            requestLocationPermissionDescription == source.requestLocationPermissionDescription &&
            requestLocationPermissionButtonTitle == source.requestLocationPermissionButtonTitle &&
            deniedLocationPermissionDescription == source.deniedLocationPermissionDescription &&
            deniedLocationPermissionButtonTitle == source.deniedLocationPermissionButtonTitle &&
            locationPermissionStatus == source.locationPermissionStatus &&
            domainModel?.weather?.currentDate == source.domainModel?.weather?.currentDate &&
            domainModel?.weather?.currentTempInCelcius == source.domainModel?.weather?.currentTempInCelcius

    }

    public func updateLocationPermissionStatus(completion: @escaping (LocationPermissionStatus) -> Void ) {
        locationPermission.authorizationStatusDescription { [weak self] (string) in
            guard let strongSelf = self else {
                return
            }
            let status = strongSelf.convertStatusFrom(string: string)
            strongSelf.locationPermissionStatus = status
            completion(status)
        }
    }

    public func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        locationPermission.askPermission { [weak self] (granted) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.locationPermissionStatus = granted ? .allowed : .denied
            completion(granted)
        }
    }

    func convertStatusFrom(string: String) -> LocationPermissionStatus {
        if string == "notDetermined" {
            return .notSet
        } else if string == "authorizedWhenInUse" || string == "authorizedAlways" {
            return .allowed
        } else {
            return .denied
        }
    }
}
