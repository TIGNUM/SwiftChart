//
//  PaymentReminderModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

enum PaymentSection: Int, CaseIterable {
    case prepared = 0
    case impact
    case grow
    case data

    static var sectionValues: [PaymentSection] {
        return [.prepared, .impact, .grow, .data]
    }

}

struct PaymentModel {
    let headerTitle: String?
    let headerSubtitle: String?
    let paymentItems: [Item]

    struct Item {
        let paymentSections: PaymentSection
        let title: String?
        let subtitle: String?
    }

    // MARK: - Properties

    func sectionItem(at indexPath: IndexPath) -> PaymentSection {
        return PaymentSection.sectionValues.item(at: indexPath.row)
    }
}
