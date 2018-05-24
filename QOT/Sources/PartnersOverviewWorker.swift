//
//  PartnersOverviewWorker.swift
//  QOT
//
//  Created by karmic on 15.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnersOverviewWorker {

    // MARK: - Properties

    let services: Services
    let syncManager: SyncManager
    let networkManager: NetworkManager

    // MARK: - Init

    init(services: Services, syncManager: SyncManager, networkManager: NetworkManager) {
        self.services = services
        self.syncManager = syncManager
        self.networkManager = networkManager
    }

    func partners() -> [Partner] {
        let realmPartners = services.partnerService.lastModifiedPartnersSortedByCreatedAtAscending(maxCount: 3)
        var partners = realmPartners.filter { $0.isValid }
        for _ in partners.count..<3 {
            // Pad with empty partners
            partners.append(Partner())
        }
        return partners
    }
}
