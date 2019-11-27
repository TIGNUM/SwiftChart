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

        var title: String {
            switch self {
            case .oura:
                return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_data_sources_section_sensors_button_oura)
            case .healthKit:
                return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_data_sources_section_sensors_label_health_app)
            }
        }

        var status: String {
            switch self {
            case .oura, .healthKit:
                return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_data_sources_section_sensors_button_disconnect)
            }
        }

        var labelStatus: String {
            switch self {
            case .oura, .healthKit:
                return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_data_sources_section_sensors_button_no_data)
            }
        }
    }
}
