//
//  WeatherViewModel.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 11/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import CoreLocation
import qot_dal

enum WeatherType: String {
    case clearSky = "Clear"
    case cloudy = "Clouds"
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
    var locationPermissionStatus: PermissionsManager.AuthorizationStatus
    var locationName: String?

    // MARK: - Init
    internal init(bucketTitle: String = "",
                  intro: String?,
                  requestLocationPermissionDescription: String?,
                  requestLocationPermissionButtonTitle: String?,
                  deniedLocationPermissionDescription: String?,
                  deniedLocationPermissionButtonTitle: String?,
                  locationName: String?,
                  locationPermissionStatus: PermissionsManager.AuthorizationStatus,
                  domain: QDMDailyBriefBucket?) {
        self.bucketTitle = bucketTitle
        self.intro = intro
        self.requestLocationPermissionDescription = requestLocationPermissionDescription
        self.requestLocationPermissionButtonTitle = requestLocationPermissionButtonTitle
        self.deniedLocationPermissionDescription = deniedLocationPermissionDescription
        self.deniedLocationPermissionButtonTitle = deniedLocationPermissionButtonTitle
        self.locationName = locationName
        self.locationPermissionStatus = locationPermissionStatus
        super.init(domain)
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
            domainModel?.weather?.updatedTimeString == source.domainModel?.weather?.updatedTimeString &&
            domainModel?.weather?.currentTempInCelcius == source.domainModel?.weather?.currentTempInCelcius

    }
}
