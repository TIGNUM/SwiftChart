//
//  MyQotSensorsModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct MyQotSensorsModel {
    let sensor: Sensor

    enum Sensor {
        case oura
        case healthKit
        case requestTracker

        var title: String {
            switch self {
            case .oura:
                return R.string.localized.sidebarSensorsMenuOuraRing ()
            case .healthKit:
                return R.string.localized.sidebarSensorsMenuHealthKit()
            case .requestTracker:
                return R.string.localized.sidebarSensorsMenuRequestSensor().capitalized
            }
        }

        var status: String {
            switch self {
            case .oura:
                return R.string.localized.sidebarSensorsMenuSensorsDisconnected()
            case .healthKit:
                return R.string.localized.sidebarSensorsMenuSensorsDisconnected()
            case .requestTracker:
                return ""
            }
        }

        var labelStatus: String {
            switch self {
            case .oura:
                return R.string.localized.sidebarSensorsMenuSeonsorsNoData()
            case .healthKit:
                return R.string.localized.sidebarSensorsMenuSeonsorsNoData()
            case .requestTracker:
                return ""
            }
        }
    }
}
