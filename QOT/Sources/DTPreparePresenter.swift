//
//  DTPreparePresenter.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTPreparePresenter: DTPresenter {

    // MARK: - Properties
    weak var prepareViewController: DTPrepareViewControllerInterface?
    var intensionViewModel: DTViewModel?

    override func hasTypingAnimation(answerType: AnswerType, answers: [DTViewModel.Answer]) -> Bool {
        if answerType == .userInput {
            hideNavigationButtonForAnimation()
        }
        return super.hasTypingAnimation(answerType: answerType, answers: answers)
    }

    override func createViewModel(_ presentationModel: DTPresentationModel) -> DTViewModel {
        return intensionViewModel ?? super.createViewModel(presentationModel)
    }

    override func previousIsHidden(questionKey: String) -> Bool {
        return questionKey == Prepare.QuestionKey.Intro || questionKey == Prepare.QuestionKey.Last
    }

    override func getNavigationButton(_ presentationModel: DTPresentationModel, isDark: Bool) -> NavigationButton? {
        if intensionViewModel != nil && presentationModel.question?.key == Prepare.Key.benefits.rawValue {
            let button = presentationModel.getNavigationButton(isHidden: false, isDark: isDark)
            button?.configure(title: R.string.localized.alertButtonTitleSave(),
                              minSelection: 0,
                              isDark: isDark)
            return button
        }
        if intensionViewModel != nil && presentationModel.question?.key != Prepare.Key.benefits.rawValue {
            let navigationButton = super.getNavigationButton(presentationModel, isDark: isDark)
            let count = intensionViewModel?.answers.filter { $0.selected }.count ?? 0
            navigationButton?.update(count: count)
            return navigationButton
        }
        return super.getNavigationButton(presentationModel, isDark: isDark)
    }
}

// MARK: - DTPrepareInterface
extension DTPreparePresenter: DTPreparePresenterInterface {
    func presentCalendarPermission(_ permissionType: AskPermission.Kind) {
        prepareViewController?.presentCalendarPermission(permissionType)
    }

    func presentCalendarSettings() {
        prepareViewController?.presentCalendarSettings()
    }
}
