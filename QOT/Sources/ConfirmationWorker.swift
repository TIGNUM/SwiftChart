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

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }
}

// MARK: - ConfirmationWorkerInterface

extension ConfirmationWorker: ConfirmationWorkerInterface {

    func model() -> ConfirmationModel {
        let buttons = [ConfirmationModel.ConfirmationButton(type: .yes, title: services.contentService.confirmationButtonYes),
                       ConfirmationModel.ConfirmationButton(type: .no, title: services.contentService.confirmationButtonNo)]
        return ConfirmationModel(title: services.contentService.confirmationTitle,
                                 description: services.contentService.confirmationDescription,
                                 buttons: buttons)
    }
}
