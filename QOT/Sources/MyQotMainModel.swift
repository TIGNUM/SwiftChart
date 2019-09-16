//
//  MyQotMainModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit

enum MyQotSection: Int, CaseIterable, Differentiable {
    case profile = 0
    case library
    case preps
    case sprints
    case data
    case toBeVision
}

struct MyQotViewModel {
    let myQotItems: [Item]

    struct Item: Differentiable {
        typealias DifferenceIdentifier = String

        func isContentEqual(to source: MyQotViewModel.Item) -> Bool {
            return myQotSections == source.myQotSections &&
                    title == source.title &&
                    subtitle == source.subtitle
        }

        var differenceIdentifier: DifferenceIdentifier {
            return "\(myQotSections)"
        }

        let myQotSections: MyQotSection
        let title: String?
        var subtitle: String?
        var showSubtitleInRed: Bool
    }

    // MARK: - Properties

    func sectionItem(at indexPath: IndexPath) -> MyQotSection {
        return MyQotSection.allCases.at(index: indexPath.row) ?? .profile
    }

    enum Section: Int, CaseIterable, Differentiable {
        case header = 0
        case body

    }
}
