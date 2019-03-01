//
//  SiriShortcutsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class SiriShortcutsWorker {

    // MARK: - Properties

    private let services: Services

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }

    // MARK: - Functions

    func siriShortcuts() -> SiriShortcutsModel {
        return SiriShortcutsModel(services: services)
    }
}
