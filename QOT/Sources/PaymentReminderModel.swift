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
    case switchAccount
    case footer

    static var expiredSectionValues: [PaymentSection] {
        return [.prepared, .impact, .grow, .data, .switchAccount, .footer]
    }

    static var notExpiredSectionValues: [PaymentSection] {
        return [.prepared, .impact, .grow, .data, .footer]
    }
}

struct PaymentModel {
    let headerTitle: String?
    let headerSubtitle: String?
    let paymentItems: [Item]

    struct Item {
        let paymentSection: PaymentSection
        let title: String?
        let subtitle: String?
    }

    // MARK: - Properties

    func sectionItem(at indexPath: IndexPath, expired: Bool) -> PaymentSection {
        return expired ? PaymentSection.expiredSectionValues.at(index: indexPath.row) ?? .prepared :
                         PaymentSection.notExpiredSectionValues.at(index: indexPath.row) ?? .prepared
    }
}
