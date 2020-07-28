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

typealias ArraySectionMyX = [ArraySection<MyX.Section, MyX.Item>]

struct MyX {
    enum Section: Int, CaseIterable, Differentiable {
        case navigationHeader = 0
        case teamHeader
        case body
    }

    var items: [MyX.Item] = []
    var teamHeaderItems: [Team.Item] = []

    func element(_ isTeam: Bool, at indexPath: IndexPath) -> MyX.Element {
        return MyX.Element.items(isTeam).at(index: indexPath.row) ?? .teamCreate
    }

    func item(for element: Element, _ isTeam: Bool) -> MyX.Item {
        let index = MyX.Element.index(isTeam, element: element)
        return items[index]
    }

    struct Item: Differentiable {
        typealias DifferenceIdentifier = String

        var teamHeaderitem: Team.Item?
        var element: MyX.Element?
        var title: String
        var subtitle: String?

        var differenceIdentifier: DifferenceIdentifier {
            return "\(element)"
        }

        func isContentEqual(to source: MyX.Item) -> Bool {
            return element == source.element &&
                title == source.title &&
                subtitle == source.subtitle
        }
    }

    struct NavigationHeader {
        let title: String
        let cta: String
    }

    enum Element: CaseIterable, Differentiable {
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

        static func index(_ isTeam: Bool, element: Element) -> Int {
            let items = MyX.Element.items(isTeam)
            if items.count == MyX.Element.allCases.count {
                switch element {
                case .teamCreate: return 0
                case .library: return 1
                case .preps: return 2
                case .sprints: return 3
                case .data: return 4
                case .toBeVision: return 5
                }
            } else {
                switch element {
                case .library: return 0
                case .toBeVision: return 1
                default: return 0
                }
            }
        }

        static func items(_ isTeam: Bool) -> [MyX.Element] {
            return isTeam ? [.library, .toBeVision] : MyX.Element.allCases
        }
    }
}
