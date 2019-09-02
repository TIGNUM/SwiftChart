//
//  DecisionTreeWorker+SyncButtons.swift
//  QOT
//
//  Created by karmic on 29.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension DecisionTreeWorker {
    func syncButtons() {
        continueButton.update(with: multiSelectionCounter,
                              defaultTitle: defaultButtonText,
                              confirmationTitle: confirmationButtonText,
                              maxSelections: maxPossibleSelections <= 1 ? 0 : maxPossibleSelections)
        NotificationCenter.default.post(name: .questionnaireBottomNavigationUpdate,
                                        object: continueButton)
    }
}
