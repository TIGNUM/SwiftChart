//
//  MyQotMainModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit
import qot_dal

typealias IndexPathArray = [ArraySection<MyQot.Section, MyQot.Item>]

enum MyQotSection: Int, CaseIterable, Differentiable {
    case teamCreate = 0
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
}

struct MyQot {
    struct Item: Differentiable {
        typealias DifferenceIdentifier = String

        let sections: MyQotSection
        let title: String?
        var subtitle: String?

        var differenceIdentifier: DifferenceIdentifier {
            return "\(sections)"
        }

        func isContentEqual(to source: MyQot.Item) -> Bool {
            return sections == source.sections &&
                    title == source.title &&
                    subtitle == source.subtitle
        }
    }

    enum Section: Int, CaseIterable, Differentiable {
        case navigationHeader = 0
        case teamHeader
        case body
    }

    let items: [Item]

    func sectionItem(at indexPath: IndexPath) -> MyQotSection {
        return MyQotSection.allCases.at(index: indexPath.row) ?? .teamCreate
    }
}
