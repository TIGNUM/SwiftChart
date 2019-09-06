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
        let bgColor = type.barButtonBackgroundColor(isMultiSelection)
        let textColor = type.barButtonTextColor(isMultiSelection)
        let buttonTitle = defaultButtonText.isEmpty ? confirmationButtonText : defaultButtonText
        navigationButton = NavigationButton(frame: CGRect.Coach.Default)
        navigationButton?.configure(title: buttonTitle, backgroundColor: bgColor, titleColor: textColor, type: type)
    }

    func syncButtons() {
        guard let navigationButton = navigationButton else { return }
        DispatchQueue.main.async {
            navigationButton.update(currentValue: self.multiSelectionCounter,
                                    maxSelections: self.maxPossibleSelections <= 1 ? 0 : self.maxPossibleSelections,
                                    defaultTitle: self.defaultButtonText,
                                    confirmationTitle: self.confirmationButtonText)
            NotificationCenter.default.post(name: .questionnaireBottomNavigationUpdate, object: self.navigationButton)
        }
    }
}
