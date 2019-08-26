//
//  MyQotMainModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

enum MyQotSection: Int, CaseIterable {
    case profile = 0
    case library
    case preps
    case sprints
    case data
    case toBeVision
}

struct MyQotViewModel {
    let myQotItems: [Item]

    struct Item {
        let myQotSections: MyQotSection
        let title: String?
        let subtitle: String?
    }

    // MARK: - Properties

    func sectionItem(at indexPath: IndexPath) -> MyQotSection {
        return MyQotSection.allCases.item(at: indexPath.row)
    }

    enum Section: Int, CaseIterable {
        case header = 0
        case body

    }
}
