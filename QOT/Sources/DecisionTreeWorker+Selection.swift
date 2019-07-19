//
//  DecisionTreeWorker+Selection.swift
//  QOT
//
//  Created by karmic on 11.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

// MARK: - Handle Selections
extension DecisionTreeWorker {
    func handleSelection(for answer: QDMAnswer) {
        switch currentQuestion?.answerType {
        case AnswerType.multiSelection.rawValue: handleMultiSelection(for: answer)
        case AnswerType.singleSelection.rawValue: handleSingleSelection(for: answer)
        default: break
        }
    }

    func handleSingleSelection(for answer: QDMAnswer) {
        guard let questionID = currentQuestion?.remoteID else { return }
        updateDecisionTree(from: answer, questionId: questionID)
        if answer.keys.contains(AnswerKey.Prepare.eventTypeSelectionCritical.rawValue) {
            prepareEventType = answer.title ?? ""
        }
        if answer.keys.contains(AnswerKey.Solve.openVisionPage.rawValue) {
            interactor?.openToBeVisionPage()
            return
        }

        switch type {
        case .solve:
            if
                currentQuestion?.key == QuestionKey.Solve.help.rawValue
                    || answer.keys.contains(AnswerKey.Solve.letsDoIt.rawValue)
                    || answer.keys.contains(AnswerKey.Solve.openResult.rawValue) {
                interactor?.openSolveResults(from: answer, type: .solve)
                return
            }
        default:
            break
        }
        if let targetQuestionId = answer.targetId(.question) {
            if currentQuestion?.key == QuestionKey.Prepare.buildCritical.rawValue
                || currentQuestion?.key == QuestionKey.MindsetShifter.showTBV.rawValue {
                if userHasToBeVision == false {
                    interactor?.openShortTBVGenerator { [weak self] in
                        self?.showNextQuestion(targetId: Prepare.Key.perceived.questionID)
                    }
                } else {
                    showNextQuestion(targetId: targetQuestionId)
                }
            } else if currentQuestion?.key == QuestionKey.Sprint.schedule.rawValue {
                handleSprintScheduling(answer)
            } else {
                showNextQuestion(targetId: targetQuestionId)
            }
        } else if currentQuestion?.key == QuestionKey.Prepare.eventTypeSelectionCritical.rawValue {
            interactor?.setTargetContentID(for: answer)
        } else if currentQuestion?.key == QuestionKey.Recovery.syntom.rawValue {
            updateRecoveryModel(fatigueAnswerId: currentQuestion?.answers.first?.remoteID ?? 0,
                                answer.remoteID ?? 0,
                                answer.targetId(.content) ?? 0)
        } else if let contentId = answer.targetId(.content) {
            showResultView(for: answer, contentID: contentId)
        }
        if let contentItemID = answer.targetId(.contentItem) {
            interactor?.streamContentItem(with: contentItemID)
        }
        if answer.keys.contains(AnswerKey.ToBeVision.uploadImage.rawValue) {
            interactor?.openImagePicker()
        }
    }

    func didSelectAnswer(_ answer: QDMAnswer) {
        switch currentQuestion?.answerType {
        case AnswerType.multiSelection.rawValue: handleMultiSelection(for: answer)
        case AnswerType.singleSelection.rawValue: handleSingleSelection(for: answer)
        default: break
        }
    }

    func didDeSelectAnswer(_ answer: QDMAnswer) {
        guard let questionID = currentQuestion?.remoteID else { return }
        let selection = DecisionTreeModel.SelectedAnswer(questionID: questionID, answer: answer)
        if multiSelectionCounter > 0 {
            interactor?.trackUserEvent(answer, .DESELECT, .ANSWER_DECISION)
            multiSelectionCounter.minus(1)
            decisionTree?.remove(selection)
            notifyCounterChanged(with: multiSelectionCounter)
        }
    }

    func handleMultiSelection(for answer: QDMAnswer) {
        guard let questionID = currentQuestion?.remoteID else { return }
        let selection = DecisionTreeModel.SelectedAnswer(questionID: questionID, answer: answer)
        if multiSelectionCounter < maxPossibleSelections {
            interactor?.trackUserEvent(answer, .SELECT, .ANSWER_DECISION)
            multiSelectionCounter.plus(1)
            decisionTree?.add(selection)
            notifyCounterChanged(with: multiSelectionCounter)
        }
    }

    func showNextQuestion(targetId: Int = 0, answer: QDMAnswer? = nil) {
        if let answer = answer {
            getNextQuestion(answer: answer) { [weak self] (node) in
                self?.showQuestion(node)
            }
        }
        if targetId != 0 {
            getNextQuestion(targetId: targetId) { [weak self] (node) in
                self?.showQuestion(node)
            }
        }
    }

    func didTapContinue() {
        switch type {
        case .recovery:
            if currentQuestion?.key == QuestionKey.Recovery.intro.rawValue {
                recoveryFatigueType = AnswerKey.Recovery.identifyFatigueSympton(decisionTreeAnswers)
            }
            if currentQuestion?.key == QuestionKey.Recovery.loading.rawValue {
                interactor?.trackUserEvent(nil, .NEXT, .TAP)
                interactor?.openRecoveryResults()
                return
            }
        case .prepareIntensions:
            interactor?.updatePrepareIntentions(decisionTree?.selectedAnswers ?? [])
            interactor?.trackUserEvent(nil, .CLOSE, .TAP)
            interactor?.dismiss()
        case .prepareBenefits:
            interactor?.updatePrepareBenefits(interactor?.userInput ?? "")
            interactor?.trackUserEvent(nil, .CLOSE, .TAP)
            interactor?.dismiss()
        case .prepare:
            if currentQuestion?.key == QuestionKey.Prepare.calendarEventSelectionCritical.rawValue ||
                currentQuestion?.key == QuestionKey.Prepare.calendarEventSelectionDaily.rawValue {
                interactor?.presentAddEventController(EKEventStore.shared)
            }
        case .sprint:
            if currentQuestion?.key == QuestionKey.Sprint.introContinue.rawValue {
                nextQuestion()
                return
            }
        case .sprintReflection:
            switch currentQuestion?.key {
            case QuestionKey.SprintReflection.Intro:
                nextQuestion()
                return
            case QuestionKey.SprintReflection.Notes01,
                 QuestionKey.SprintReflection.Notes02,
                 QuestionKey.SprintReflection.Notes03:
                    updateSprint(sprintToUpdate, userInput: userInput)
                    nextQuestion()
                    return
            default:
                break
            }
        default:
            break
        }
        if currentQuestion?.answerType == AnswerType.lastQuestion.rawValue ||
            currentQuestion?.key == QuestionKey.MindsetShifterTBV.review.rawValue {
            interactor?.dismiss()
        } else if currentQuestion?.key == QuestionKey.Prepare.benefitsInput.rawValue {
            guard let answer = currentQuestion?.answers.first else { return }
            handleSingleSelection(for: answer)
        } else {
            switch currentQuestion?.key {
            case QuestionKey.MindsetShifter.openTBV.rawValue:
                interactor?.openShortTBVGenerator(completion: nil)
            case QuestionKey.MindsetShifter.check.rawValue:
                interactor?.openMindsetShifterChecklist(from: decisionTreeAnswers)
            case QuestionKey.ToBeVision.create.rawValue,
                 QuestionKey.ToBeVision.review.rawValue:
                interactor?.toBeVisionDidChange()
                interactor?.dismiss()
            default: break
            }
            getNextQuestion(answer: decisionTree?.selectedAnswers.last?.answer) { [weak self] (node) in
                self?.showQuestion(node)
                self?.updateMultiSelectionCounter()
            }
            interactor?.trackUserEvent(nil, .NEXT, .TAP)
        }
    }
}

private extension DecisionTreeWorker {
    func nextQuestion() {
        let answer = currentQuestion?.answers.first
        getNextQuestion(answer: answer) { [weak self] (node) in
            self?.interactor?.trackUserEvent(answer, .NEXT, .TAP)
            self?.showQuestion(node)
        }
    }

    func notifyCounterChanged(with value: Int) {
        let selectionCounter = UserInfo.multiSelectionCounter.pair(for: value)
        let selectedAnswers = UserInfo.selectedAnswers.pair(for: decisionTreeAnswers)
        NotificationCenter.default.post(name: .didUpdateSelectionCounter,
                                        object: nil,
                                        userInfo: [selectionCounter.key: selectionCounter.value,
                                                   selectedAnswers.key: selectedAnswers.value])
    }

    func showQuestion(_ node: DecisionTreeNode) {
        if let question = node.question {
            interactor?.showQuestion(question,
                                     extraAnswer: node.generatedAnswer,
                                     filter: answersFilter(),
                                     selectedAnswers: selectedAnswers,
                                     direction: .forward,
                                     animated: false)
        }
    }
}

// MARK: - Handle Prepare ResultView
extension DecisionTreeWorker {
    func showResultView(for answer: QDMAnswer, contentID: Int) {
        if answer.keys.contains(AnswerKey.Prepare.openCheckList.rawValue) {
            interactor?.openPrepareResults(contentID)
        } else if currentQuestion?.key == QuestionKey.Prepare.eventTypeSelectionDaily.rawValue {
            let level = QDMUserPreparation.Level.LEVEL_DAILY
            PreparationManager.main.create(level: level,
                                           contentCollectionId: level.contentID,
                                           relatedStrategyId: answer.decisions.first?.targetTypeId ?? 0,
                                           eventType: answer.title ?? "",
                                           event: selectedEvent) { [weak self] (preparation) in
                                            if let preparation = preparation {
                                                self?.interactor?.openPrepareResults(preparation,
                                                                                     self?.decisionTree?.selectedAnswers ?? [])
                                            }
            }
        } else if currentQuestion?.key == QuestionKey.Prepare.benefitsInput.rawValue {
            let level = QDMUserPreparation.Level.LEVEL_CRITICAL
            PreparationManager.main.create(level: level,
                                           benefits: interactor?.userInput,
                                           answerFilter: answersFilter(),
                                           contentCollectionId: level.contentID,
                                           relatedStrategyId: answer.decisions.first?.targetTypeId ?? 0,
                                           strategyIds: [interactor?.relatedStrategyID ?? 0],
                                           eventType: prepareEventType,
                                           event: selectedEvent) { [weak self] (preparation) in
                                            if let preparation = preparation {
                                                self?.interactor?.openPrepareResults(preparation,
                                                                                     self?.decisionTree?.selectedAnswers ?? [])
                                            }
            }
        } else {
            interactor?.displayContent(with: contentID)
        }
    }
}
