//
//  ConfirmationWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ConfirmationWorker {

    // MARK: - Properties
    private var title = ""
    private var description = ""
    private var buttonTitleDismiss = ""
    private var buttonTitleConfirm = ""
    private let kind: Confirmation.Kind
    private let dispatchGroup = DispatchGroup()
    private lazy var contentService = qot_dal.ContentService.main

    // MARK: - Init
    init(type: Confirmation.Kind) {
        self.kind = type
    }
}

// MARK: - Public
extension ConfirmationWorker {
    func getModel(_ completion: @escaping (Confirmation) -> Void) {
        kind.tags.forEach { getItem($0) }
        dispatchGroup.notify(queue: .main) { [unowned self] in
            completion(Confirmation(title: self.title,
                                    description: self.description,
                                    buttonTitleDismiss: self.buttonTitleDismiss,
                                    buttonTitleConfirm: self.buttonTitleConfirm))
        }
    }
}

// MARK: - ContentService ContentItem
private extension ConfirmationWorker {
    func getItem(_ tag: Confirmation.Tag) {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(tag.predicate) { [unowned self] (contentItem) in
            let text = contentItem?.valueText ?? ""
            switch tag {
            case .mindsetTitle, .recoveryTitle, .solveTitle:
                self.title = text
            case .mindsetDescription, .recoveryDescription, .solveDescription:
                self.description = text
            case .mindsetButtonNo, .recoveryButtonNo, .solveButtonNo:
                self.buttonTitleDismiss = text
            case .mindsetButtonYes, .recoveryButtonYes, .solveButtonYes:
                self.buttonTitleConfirm = text
            }
            self.dispatchGroup.leave()
        }
    }
}
