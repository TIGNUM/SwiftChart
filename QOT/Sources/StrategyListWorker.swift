//
//  StrategyListWorker.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class StrategyListWorker {

    // MARK: - Properties

    let services: Services
    private let selectedStrategyID: Int
    lazy var contentList: [ContentCollection] = {
        guard let contentList = services.contentService.contentCategory(id: selectedStrategyID)?.contentCollections else { return [] }
        return Array(contentList).filter { $0.section == Database.Section.learnStrategy.value }
    }()

    // MARK: - Init

    init(services: Services, selectedStrategyID: Int) {
        self.services = services
        self.selectedStrategyID = selectedStrategyID
    }
}
