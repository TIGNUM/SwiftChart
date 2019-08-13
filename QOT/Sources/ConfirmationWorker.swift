//
//  ConfirmationWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ConfirmationWorker {

    // MARK: - Properties
    private let services: Services
    private let kind: Confirmation.Kind

    private var contentService: ContentService {
        return services.contentService
    }

    // MARK: - Init
    init(services: Services, type: Confirmation.Kind) {
        self.services = services
        self.kind = type
    }
}

// MARK: - ConfirmationWorkerInterface
extension ConfirmationWorker: ConfirmationWorkerInterface {
    var model: Confirmation {
        return Confirmation(title: title, description: description)
    }
}

// MARK: - Values
private extension ConfirmationWorker {
    var title: String {
        switch kind {
        case .mindsetShifter:
            return contentService.mindsetShifterConfirmationTitle
        case .recovery:
            return R.string.localized.profileConfirmationHeader()
        case .solve:
            return contentService.solveConfirmationTitle
        }
    }

    var description: String {
        switch kind {
        case .mindsetShifter:
            return contentService.mindsetShifterConfirmationDescription
        case .recovery:
            return R.string.localized.profileConfirmationDescription()
        case .solve:
            return contentService.solveConfirmationDescription
        }
    }
}
