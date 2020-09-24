//
//  MyQotMainModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

enum MyX {
    enum Section: Int, CaseIterable {
        case navigationHeder = 0
        case teamHeader
        case items

        func itemCount(_ isTeam: Bool) -> Int {
            switch self {
            case .navigationHeder,
                 .teamHeader: return 1
            case .items: return MyX.Item.items(isTeam).count
            }
        }
    }

    enum Item: String, CaseIterable {
        case teamCreate
        case library
        case preps
        case sprints
        case data
        case toBeVision

        func title(isTeam: Bool) -> String {
            switch self {
            case .teamCreate:
                return AppTextService.get(.my_x_team_create_header)
            case .library:
                return AppTextService.get(isTeam ? .my_x_section_team_library_title : .my_qot_section_my_library_title)
            case .preps:
                return AppTextService.get(.my_qot_section_my_plans_title)
            case .sprints:
                return AppTextService.get(.my_qot_section_my_sprints_title)
            case .data:
                return AppTextService.get(.my_qot_section_my_data_title)
            case .toBeVision:
                return AppTextService.get(isTeam ? .my_x_section_team_tbv_title : .my_qot_section_my_tbv_title)
            }
        }

        static func items(_ isTeam: Bool) -> [MyX.Item] {
            return isTeam ? [.library, .toBeVision] : MyX.Item.allCases
        }
    }
}
