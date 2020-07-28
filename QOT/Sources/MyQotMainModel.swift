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

    enum Item: CaseIterable, MyQotMainWorker {
        case teamCreate
        case library
        case preps
        case sprints
        case data
        case toBeVision

        var title: String {
            switch self {
            case .teamCreate: return AppTextService.get(.my_x_team_create_header)
            case .library: return AppTextService.get(.my_qot_section_my_library_title)
            case .preps: return AppTextService.get(.my_qot_section_my_plans_title)
            case .sprints: return AppTextService.get(.my_qot_section_my_sprints_title)
            case .data: return AppTextService.get(.my_qot_section_my_data_title)
            case .toBeVision: return AppTextService.get(.my_qot_section_my_tbv_title)
            }
        }

        func subtitle(_ completion: @escaping (String?) -> Void) {
            switch self {
            case .teamCreate: completion(AppTextService.get(.my_x_team_create_header))
            case .library: completion("")
            case .preps:
               getPreparationSubtitle(completion)
            case .sprints:
                getCurrentSprintName(completion)
            case .data:
                getMyDataSubtitle(completion)
            case .toBeVision:
                getToBeVisionSubtitle(completion)
            }
        }

        static func items(_ isTeam: Bool) -> [MyX.Item] {
            return isTeam ? [.library, .toBeVision] : MyX.Item.allCases
        }

        static func indexPathUpdate() -> [IndexPath] {
            return [IndexPath(item: 0, section: 2),
                    IndexPath(item: 2, section: 2),
                    IndexPath(item: 3, section: 2),
                    IndexPath(item: 4, section: 2)]
        }
    }
}
