//
//  MyQotSensorsModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct MyQotSensorsModel {
    let sensor: Sensor

    enum Sensor {
        case oura
        case healthKit
        case requestTracker

        var title: String {
            switch self {
            case .oura:
                return AppTextService.get(AppTextKey.my_qot_sensors_menu_oura_title)
            case .healthKit:
                return AppTextService.get(AppTextKey.my_qot_sensors_menu_health_kit_title)
            case .requestTracker:
                return AppTextService.get(AppTextKey.my_qot_sensors_menu_tracker_title)
            }
        }

        var status: String {
            switch self {
            case .oura, .healthKit:
                return AppTextService.get(AppTextKey.my_qot_sensors_menu_disconnected_title)
            case .requestTracker:
                return ""
            }
        }

        var labelStatus: String {
            switch self {
            case .oura, .healthKit:
                return AppTextService.get(AppTextKey.my_qot_sensors_menu_no_data_title)
            case .requestTracker:
                return ""
            }
        }
    }
}
