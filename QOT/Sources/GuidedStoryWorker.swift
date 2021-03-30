//
//  GuidedStoryWorker.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class GuidedStoryWorker {
    var jounreyItems = [QDMGuidedStory]()
    var questions = [QDMQuestion]()
    var selectedAnswers = [String: QDMAnswer]()
    var targetContent: QDMContentCollection?
    private var targetContents = [QDMContentCollection]()
    private var currentQuestionKey = GuidedStory.Survey.QuestionKey.intro.rawValue

    var isLastQuestion: Bool {
        return currentQuestionKey == GuidedStory.Survey.QuestionKey.last.rawValue
    }

    func question() -> QDMQuestion? {
        return questions.first(where: { $0.key == currentQuestionKey })
    }

    func answers() -> [QDMAnswer] {
        let answers = question()?.answers
        return answers?.sorted(by: { $0.sortOrder ?? .zero < $1.sortOrder ?? .zero }) ?? []
    }

    func answer(at index: Int) -> QDMAnswer? {
        return answers().at(index: index)
    }

    func getQuestions(_ completion: @escaping () -> Void) {
        QuestionService.main.questionsWithQuestionGroup(.Onboarding, ascending: true) { (questions) in
            self.questions = questions ?? []
            completion()
        }
    }

    func getTargetContents() {
        ContentService.main.getContentCategory(.OnboardingSurvey) { [weak self] (category) in
            self?.targetContents = category?.contentCollections ?? []
        }
    }

    func didSelectAnswer(at index: Int) {
        selectedAnswers[currentQuestionKey] = answer(at: index)
    }

    func didTabNext() {
        saveSelectedUserAnswer()
        updateCurrentQuestionKey()
    }
}

// MARK: - Journey
extension GuidedStoryWorker {
    func loadJourney() {
        saveSelectedUserAnswer()
        setSelectedJourney()
    }
}

// MARK: - Private
private extension GuidedStoryWorker {
    func saveSelectedUserAnswer() {
        let currentQuestion = question()
        let lastSelectedAnswer = selectedAnswers.first?.value
        if let answer = lastSelectedAnswer, let questionId = currentQuestion?.remoteID {
            QuestionService.main.saveOnboardingAnswer(answer: answer,
                                                      questionId: questionId,
                                                      questionGroupId: QuestionGroup.Onboarding.rawValue) { (error) in
                if let error = error {
                    log("Error while saveOnboardingAnswer -> \(error)", level: .error)
                }
            }
        }
    }

    func updateCurrentQuestionKey() {
        let nextQuestionId = selectedAnswers.first?.value.targetId(.question)
        if let nextQuestionKey = questions.first(where: { $0.remoteID == nextQuestionId })?.key {
            currentQuestionKey = nextQuestionKey
        }
    }

    func setSelectedJourney() {
        let targetId = selectedAnswers.first?.value.targetId(.content)
        targetContent = targetContents.first(where: { $0.remoteID == targetId })
        let story = ContentService.main.createOnboardingGuidedStory(targetContent: targetContent)
        jounreyItems = story.sorted(by: { $0.sortOrder < $1.sortOrder })
    }
}
