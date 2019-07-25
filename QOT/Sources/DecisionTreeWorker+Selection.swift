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
        if answer.keys.contains(AnswerKey.Solve.openVisionPage.rawValue) {
            interactor?.openToBeVisionPage()
            return
        }

        switch currentQuestion?.key {
        case QuestionKey.Prepare.BuildCritical,
             QuestionKey.MindsetShifter.showTBV.rawValue:
            if let targetQuestionId = answer.targetId(.question) {
                showTBV(targetQuestionId: targetQuestionId)
            }
        case QuestionKey.Prepare.EventTypeSelectionDaily:
            prepareEventType = answer.subtitle ?? ""
        case QuestionKey.Sprint.schedule.rawValue:
            handleSprintScheduling(answer)
        case QuestionKey.Prepare.EventTypeSelectionCritical:
            setTargetContentID(for: answer)
            prepareEventType = answer.subtitle ?? ""
        case QuestionKey.Recovery.syntom.rawValue:
            updateRecoveryModel(fatigueAnswerId: currentQuestion?.answers.first?.remoteID ?? 0,
                                answer.remoteID ?? 0,
                                answer.targetId(.content) ?? 0)
        case QuestionKey.Solve.help.rawValue
            where answer.keys.contains(AnswerKey.Solve.letsDoIt.rawValue) || answer.keys.contains(AnswerKey.Solve.openResult.rawValue):
            interactor?.openSolveResults(from: answer, type: .solve)
        default:
            break
        }

        if let targetQuestionId = answer.targetId(.question) {
            showNextQuestion(targetId: targetQuestionId)
        } else if let contentId = answer.targetId(.content) {
            showResultView(for: answer, contentID: contentId)
        } else if let contentItemID = answer.targetId(.contentItem) {
            interactor?.streamContentItem(with: contentItemID)
        } else if answer.keys.contains(AnswerKey.ToBeVision.uploadImage.rawValue) {
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
        case .prepareIntentions:
            didUpdatePrepareIntentions(decisionTree?.selectedAnswers ?? [])
            interactor?.trackUserEvent(nil, .CLOSE, .TAP)
            interactor?.dismiss()
        case .prepareBenefits:
            didUpdateBenefits(interactor?.userInput ?? "")
            interactor?.trackUserEvent(nil, .CLOSE, .TAP)
            interactor?.dismiss()
        case .prepare:
            switch currentQuestion?.key {
            case QuestionKey.Prepare.CalendarEventSelectionCritical,
                 QuestionKey.Prepare.CalendarEventSelectionDaily:
                interactor?.presentAddEventController(EKEventStore.shared)
            case QuestionKey.Prepare.ShowTBV:
                nextQuestion()
                return
            default:
                break
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
        } else if currentQuestion?.key == QuestionKey.Prepare.BenefitsInput,
            let answer = currentQuestion?.answers.first {
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

// MARK: - Private
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
