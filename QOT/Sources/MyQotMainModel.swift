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
            case .preps: completion("")
            case .sprints: completion("")
            case .data: completion("")
            case .toBeVision: completion("")
            }
        }

//        private func createMyData(irScore: Int?) -> MyX.Item? {
//            let subtitle = String(irScore ?? 0) + AppTextService.get(.my_qot_section_my_data_subtitle)
//            return getItem(in: .data, subTitle: subtitle)
//        }
//
//        private func createToBeVision(date: Date?) -> MyX.Item? {
//            guard date != nil else {
//                return getItem(in: .toBeVision)
//            }
//            let since = Int(timeElapsed(date: date).rounded())
//            let key: AppTextKey = since >= 3 ? .my_qot_section_my_tbv_subtitle_more_than : .my_qot_section_my_tbv_subtitle_less_than_3_months
//            return getItem(in: .toBeVision, subTitle: AppTextService.get(key))
//        }
//
//        private func createPreps(dateString: String?, eventType: String?) -> MyX.Item? {
//            var subtitle = ""
//            if let dateString = dateString, let eventType = eventType {
//                subtitle = dateString + " " + eventType
//            }
//            return getItem(in: .preps, subTitle: subtitle)
//        }

//        private func timeElapsed(date: Date?) -> Double {
//            if let monthSince = date?.months(to: Date()), monthSince > 1 {
//                return Double(monthSince)
//            }
//            return 0
//        }
//
//        private func nextPrep(completion: @escaping (String?) -> Void) {
//            nextPrep { (preparation) in
//                completion(preparation)
//            }
//        }
//
//        private func getCurrentSprintName(completion: @escaping (String?) -> Void) {
//            getCurrentSprintName { (sprint) in
//                completion(sprint)
//            }
//        }
//
//        private func nextPrepType(completion: @escaping (String?) -> Void) {
//            nextPrepType { ( preparation) in
//
//                (preparation)
//            }
//        }
//
//        private func toBeVisionDate(completion: @escaping (Date?) -> Void) {
//            toBeVisionDate { (toBeVisionDate) in
//                completion(toBeVisionDate)
//            }
//        }

        static func index(_ isTeam: Bool, item: MyX.Item) -> Int {
            let items = MyX.Item.items(isTeam)
            if items.count == MyX.Item.allCases.count {
                switch item {
                case .teamCreate: return 0
                case .library: return 1
                case .preps: return 2
                case .sprints: return 3
                case .data: return 4
                case .toBeVision: return 5
                }
            } else {
                switch item {
                case .library: return 0
                case .toBeVision: return 1
                default: return 0
                }
            }
        }

        static func items(_ isTeam: Bool) -> [MyX.Item] {
            return isTeam ? [.library, .toBeVision] : MyX.Item.allCases
        }
    }
}
