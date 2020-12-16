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
    var deniedLocationPermissionDescription: String?
    var accessLocationPermissionTitle: String?
    var locationPermissionStatus: PermissionsManager.AuthorizationStatus
    var locationName: String?
    var weatherImage: String?

    // MARK: - Init
    internal init(bucketTitle: String = "",
                  intro: String?,
                  requestLocationPermissionDescription: String?,
                  deniedLocationPermissionDescription: String?,
                  accessLocationPermissionTitle: String?,
                  locationName: String?,
                  locationPermissionStatus: PermissionsManager.AuthorizationStatus,
                  weatherImage: String?,
                  domain: QDMDailyBriefBucket?) {
        self.bucketTitle = bucketTitle
        self.intro = intro
        self.weatherImage = weatherImage
        self.requestLocationPermissionDescription = requestLocationPermissionDescription
        self.deniedLocationPermissionDescription = deniedLocationPermissionDescription
        self.accessLocationPermissionTitle = accessLocationPermissionTitle
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
            deniedLocationPermissionDescription == source.deniedLocationPermissionDescription &&
            weatherImage == source.weatherImage &&
            accessLocationPermissionTitle == source.accessLocationPermissionTitle &&
            locationPermissionStatus == source.locationPermissionStatus &&
            domainModel?.weather?.currentDate == source.domainModel?.weather?.currentDate &&
            domainModel?.weather?.updatedTimeString == source.domainModel?.weather?.updatedTimeString &&
            domainModel?.weather?.currentTempInCelcius == source.domainModel?.weather?.currentTempInCelcius
    }
}
