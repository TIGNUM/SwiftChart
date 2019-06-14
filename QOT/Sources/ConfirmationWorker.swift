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
    private let type: ConfirmationType

    private var contentService: ContentService {
        return services.contentService
    }

    // MARK: - Init

    init(services: Services, type: ConfirmationType) {
        self.services = services
        self.type = type
    }
}

// MARK: - ConfirmationWorkerInterface

extension ConfirmationWorker: ConfirmationWorkerInterface {

    var model: ConfirmationModel {
        return ConfirmationModel(title: title, description: description, buttons: [buttonYes, buttonNo])
    }
}

// MARK: - Values

private extension ConfirmationWorker {

    var buttonYes: ConfirmationModel.ConfirmationButton {
        switch type {
        case .mindsetShifter:
            return ConfirmationModel.ConfirmationButton(type: .yes, title: contentService.mindsetShifterConfirmationTitle)
        case .solve:
            return ConfirmationModel.ConfirmationButton(type: .yes, title: contentService.solveConfirmationTitle)
        }
    }

    var buttonNo: ConfirmationModel.ConfirmationButton {
        switch type {
        case .mindsetShifter:
            return ConfirmationModel.ConfirmationButton(type: .no, title: contentService.mindsetShifterConfirmationDescription)
        case .solve:
            return ConfirmationModel.ConfirmationButton(type: .no, title: contentService.solveConfirmationDescription)
        }
    }

    var title: String {
        switch type {
        case .mindsetShifter:
            return contentService.mindsetShifterConfirmationTitle
        case .solve:
            return contentService.solveConfirmationTitle
        }
    }

    var description: String {
        switch type {
        case .mindsetShifter:
            return contentService.mindsetShifterConfirmationDescription
        case .solve:
            return contentService.solveConfirmationDescription
        }
    }
}
