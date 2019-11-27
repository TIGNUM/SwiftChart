//
//  DTSprintReflectionInteractor.swift
//  QOT
//
//  Created by Michael Karbe on 17.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSprintReflectionInteractor: DTInteractor {

    // MARK: - Properties
    var sprint: QDMSprint?
    weak var sprintRefelctionPresenter: DTSprintReflectionPresenter?
    private lazy var sprintReflectionWorker: DTSprintReflectionWorker? = DTSprintReflectionWorker()

    override init(_ presenter: DTPresenterInterface, questionGroup: QuestionGroup, introKey: String) {
        super.init(presenter, questionGroup: questionGroup, introKey: introKey)
    }

    override func loadIntroQuestion(_ firstQuestion: QDMQuestion?) {
        let questionUpdate = getTitleUpdate(selectedAnswers: [], questionKey: nil)
        let presentationModel = createPresentationModel(questionId: firstQuestion?.remoteID ?? 0,
                                                        answerFilter: introKey,
                                                        userInputText: nil,
                                                        questionUpdate: questionUpdate,
                                                        questions: questions)
        let node = Node(questionId: firstQuestion?.remoteID,
                        answerFilter: nil,
                        titleUpdate: questionUpdate)
        presentedNodes.append(node)
        sprintRefelctionPresenter?.showNextQuestion(presentationModel, isDark: isDark)
    }

    override func getTitleUpdate(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        return sprint?.title
    }

    override func didUpdateUserInput(_ text: String, questionKey: String) {
        switch questionKey {
        case SprintReflection.QuestionKey.Notes01: sprint?.notesLearnings = text
        case SprintReflection.QuestionKey.Notes02: sprint?.notesReflection = text
        case SprintReflection.QuestionKey.Notes03: sprint?.notesBenefits = text
        default: break
        }
    }
}

// MARK: - DTSprintReflectionInteractorInterface
extension DTSprintReflectionInteractor: DTSprintReflectionInteractorInterface {
    func updateSprint() {
        sprintReflectionWorker?.updateSprint(sprint: sprint)
    }
}
