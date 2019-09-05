//
//  DecisionTreeWorker+SyncButtons.swift
//  QOT
//
//  Created by karmic on 29.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension DecisionTreeWorker {
    func setupContinueButton() {
        let isMultiSelection = currentQuestion?.answerType == AnswerType.multiSelection.rawValue
        let bgColor: UIColor = isMultiSelection ? .carbonNew08 : .carbonNew
        let textColor: UIColor = isMultiSelection ? .carbonNew30 : .accent
        let buttonTitle = defaultButtonText.isEmpty ? confirmationButtonText : defaultButtonText
        navigationButton = NavigationButton(frame: CGRect.Coach.Default)
        navigationButton?.configure(title: buttonTitle, backgroundColor: bgColor, titleColor: textColor)
    }

    func syncButtons() {
        guard let navigationButton = navigationButton else { return }
        navigationButton.update(currentValue: multiSelectionCounter,
                                maxSelections: maxPossibleSelections <= 1 ? 0 : maxPossibleSelections,
                                defaultTitle: defaultButtonText,
                                confirmationTitle: confirmationButtonText)
        NotificationCenter.default.post(name: .questionnaireBottomNavigationUpdate, object: navigationButton)
    }
}
