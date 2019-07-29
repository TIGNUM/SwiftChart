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

        switch type {
        case .recovery,
             .sprint:
            handleSelectionSprint(answer)

        case .mindsetShifter:
            handleSelectionMindsetShifter(answer)

        case .mindsetShifterTBV:
            handleSelectionTBVGeneratorShort(answer)

        case .prepare,
             .prepareBenefits,
             .prepareIntentions:
            handleSelectionPrepare(answer)

        case .solve:
            handleSelectionSolve(answer)

        case .toBeVisionGenerator:
            handleSelectionTBVGenerator(answer)

        case .sprintReflection:
            return
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

    @objc func showNextQuestionAfterMediaPlayerWillDismiss() {
        showNextQuestion(targetId: nextQuestionId, answer: nil)
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
            if currentQuestion?.key == QuestionKey.Sprint.IntroContinue {
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
            currentQuestion?.key == QuestionKey.MindsetShifterTBV.Review {
            interactor?.dismiss()
        } else if currentQuestion?.key == QuestionKey.Prepare.BenefitsInput,
            let answer = currentQuestion?.answers.first {
                handleSingleSelection(for: answer)
        } else {
            switch currentQuestion?.key {
            case QuestionKey.MindsetShifter.OpenTBV:
                interactor?.openShortTBVGenerator(completion: nil)
            case QuestionKey.MindsetShifter.Check:
                interactor?.openMindsetShifterChecklist(from: decisionTreeAnswers)
            case QuestionKey.ToBeVision.Create,
                 QuestionKey.ToBeVision.Review:
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

private extension DecisionTreeWorker {
    func showNextQuestionIfExist(_ answer: QDMAnswer) {
        if let targetQuestionId = answer.targetId(.question) {
            showNextQuestion(targetId: targetQuestionId)
        }
    }
}

// MARK: - Sprint Selection
private extension DecisionTreeWorker {
    func handleSelectionSprint(_ answer: QDMAnswer) {
        switch currentQuestion?.key {
        case QuestionKey.Sprint.Intro,
             QuestionKey.Sprint.IntroContinue,
             QuestionKey.Sprint.Last,
             QuestionKey.Sprint.Selection:
            showNextQuestionIfExist(answer)
        case QuestionKey.Sprint.Schedule:
            handleSprintScheduling(answer)
        default:
            return
        }
    }
}

// MARK: - Prepare
private extension DecisionTreeWorker {
    func handleSelectionPrepare(_ answer: QDMAnswer) {
        switch currentQuestion?.key {
        case QuestionKey.Prepare.Intro:
            if answer.keys.contains(AnswerKey.Prepare.OpenCheckList) {
                if let contentId = answer.targetId(.content) {
                    showResultView(for: answer, contentID: contentId)
                }
            } else {
                showNextQuestionIfExist(answer)
            }

        case QuestionKey.Prepare.BuildCritical:
            if let targetQuestionId = answer.targetId(.question) {
                showTBV(targetQuestionId: targetQuestionId)
            }

        case QuestionKey.Prepare.EventTypeSelectionCritical:
            setTargetContentID(for: answer)
            prepareEventType = answer.subtitle ?? ""
            if let targetQuestionId = answer.targetId(.question) {
                showNextQuestion(targetId: targetQuestionId)
                return
            }

        case QuestionKey.Prepare.EventTypeSelectionDaily:
            prepareEventType = answer.subtitle ?? ""
            if let contentId = answer.targetId(.content) {
                showResultView(for: answer, contentID: contentId)
            }

        case QuestionKey.Prepare.BenefitsInput:
            if let contentId = answer.targetId(.content) {
                showResultView(for: answer, contentID: contentId)
            }
        case QuestionKey.Prepare.BuildCritical,
             QuestionKey.Prepare.CalendarEventSelectionCritical,
             QuestionKey.Prepare.CalendarEventSelectionDaily,
             QuestionKey.Prepare.EventTypeSelectionCritical,
             QuestionKey.Prepare.SelectExisting,
             QuestionKey.Prepare.ShowTBV:
            showNextQuestionIfExist(answer)

        default:
            return
        }
    }
}

// MARK: - TBV Generator Short
private extension DecisionTreeWorker {
    func handleSelectionTBVGeneratorShort(_ answer: QDMAnswer) {
        switch currentQuestion?.key {
        case QuestionKey.MindsetShifterTBV.Home,
             QuestionKey.MindsetShifterTBV.Intro,
             QuestionKey.MindsetShifterTBV.Work,
             QuestionKey.MindsetShifterTBV.Review:
            showNextQuestionIfExist(answer)

        default:
            return
        }
    }
}

// MARK: - Solve
private extension DecisionTreeWorker {
    func handleSelectionSolve(_ answer: QDMAnswer) {
        if answer.keys.contains(AnswerKey.Solve.letsDoIt.rawValue)
            || answer.keys.contains(AnswerKey.Solve.openResult.rawValue) {
                interactor?.openSolveResults(from: answer, type: .solve)
        } else {
            showNextQuestionIfExist(answer)
        }
    }
}

// MARK: - MindsetShifter
private extension DecisionTreeWorker {
    func handleSelectionMindsetShifter(_ answer: QDMAnswer) {
        switch currentQuestion?.key {
        case QuestionKey.MindsetShifter.ShowTBV:
            if let targetQuestionId = answer.targetId(.question) {
                showTBV(targetQuestionId: targetQuestionId)
            }

        default:
            showNextQuestionIfExist(answer)
        }
    }
}

// MARK: - TBV Generator
private extension DecisionTreeWorker {
    func handleSelectionTBVGenerator(_ answer: QDMAnswer) {
        switch currentQuestion?.key {
        case QuestionKey.ToBeVision.Intro:
            showNextQuestionIfExist(answer)
        case QuestionKey.ToBeVision.Instructions:
            if let contentItemID = answer.targetId(.contentItem) {
                interactor?.streamContentItem(with: contentItemID)
                if let targetQuestionId = answer.targetId(.question) {
                    nextQuestionId = targetQuestionId
                }
            } else if let contentId = answer.targetId(.content) {
                showResultView(for: answer, contentID: contentId)
                if let targetQuestionId = answer.targetId(.question) {
                    showNextQuestion(targetId: targetQuestionId)
                }
            }

        default:
            showNextQuestionIfExist(answer)
        }
    }
}
