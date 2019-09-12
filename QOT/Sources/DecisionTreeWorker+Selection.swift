//
//  DecisionTreeWorker+Selection.swift
//  QOT
//
//  Created by karmic on 11.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

// MARK: - Select / DeSelect
extension DecisionTreeWorker {
    func didSelectAnswer(_ answer: QDMAnswer) {
        switch currentQuestion?.answerType {
        case AnswerType.multiSelection.rawValue:
            handleMultiSelection(for: answer)
        case AnswerType.singleSelection.rawValue:
            handleSingleSelection(for: answer)
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
}

// MARK: - Selection Handling
extension DecisionTreeWorker {
    func handleSingleSelection(for answer: QDMAnswer) {
        if answer.keys.contains(AnswerKey.Solve.openVisionPage.rawValue) {
            interactor?.openToBeVisionPage()
            return
        }

        switch type {
        case .recovery: handleSelectionRecovery(answer)
        case .sprint: handleSelectionSprint(answer)
        case .mindsetShifter: handleSelectionMindsetShifter(answer)
        case .mindsetShifterTBV,
             .mindsetShifterTBVOnboarding,
             .mindsetShifterTBVPrepare: handleSelectionTBVGeneratorShort(answer)
        case .prepare: handleSelectionPrepare(answer)
        case .solve: handleSelectionSolve(answer)
        case .toBeVisionGenerator: handleSelectionTBVGenerator(answer)
        case .sprintReflection,
             .takeaways,
             .prepareIntentions,
             .prepareBenefits: return
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

    @objc func showNextQuestionDismiss() {
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
        case .mindsetShifterTBVOnboarding,
             .mindsetShifterTBVPrepare,
             .mindsetShifterTBV:
            nextQuestion()
            return
        case .toBeVisionGenerator:
            switch currentQuestion?.key {
            case QuestionKey.ToBeVision.Instructions,
                 QuestionKey.ToBeVision.Create:
                nextQuestion()
                return
            default:
                break
            }
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
            return
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
        case .mindsetShifter:
            switch currentQuestion?.key {
            case QuestionKey.MindsetShifter.OpenTBV:
                if let targetQuestionId = currentQuestion?.answers.first?.targetId(.question) {
                    showTBV(targetQuestionId: targetQuestionId)
                    return
                }
            case QuestionKey.MindsetShifter.ShowTBV:
                if let targetQuestionId = currentQuestion?.answers.first?.targetId(.question) {
                    showNextQuestion(targetId: targetQuestionId)
                    return
                }
            //TODO: Remove in clean up task.
            case QuestionKey.MindsetShifter.Check:
//                getShifterResultItem(answers: decisionTreeAnswers) { [unowned self] (resultItem) in
//                    self.interactor?.openMindsetShifterResult(resultItem: resultItem) {
//                        self.nextQuestionId = self.currentQuestion?.answers.first?.targetId(.question) ?? 0
//                    }
//                }
                return
            case QuestionKey.MindsetShifter.Last:
                interactor?.dismissAndGoToMyQot()
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
            showNextQuestion(targetId: targetQuestionId, answer: answer)
        }
    }
}

// MARK: - MindsetShifter
private extension DecisionTreeWorker {
    //TODO: Remove in clean up task.
//    func getShifterResultItem(answers: [QDMAnswer],
//                              completion: @escaping (MindsetResult.Item) -> Void) {
//        let dispatchGroup = DispatchGroup()
//        let triggerAnswers = filteredAnswers([answers[0]], filter: .Trigger)
//        let reactionAnswers = filteredAnswers(answers, filter: .Reaction)
//        let lowAnswers = filteredAnswers(answers, filter: .LowPerfomance)
//        var highItems: [QDMContentItem] = []
//        let contentItemIds = answers.compactMap { $0.targetId(.contentItem) }
//
//        dispatchGroup.enter()
//        getHighItems(contentItemIds) { (items) in
//            highItems = items
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            let resultItem = MindsetResult.Item(triggerAnswerId: triggerAnswers.map { $0.remoteID ?? 0 }.first ?? 0,
//                                                reactionsAnswerIds: reactionAnswers.map { $0.remoteID ?? 0 },
//                                                lowPerformanceAnswerIds: lowAnswers.map { $0.remoteID ?? 0 },
//                                                highPerformanceContentItemIds: contentItemIds,
//                                                trigger: triggerAnswers.map { $0.subtitle ?? "" }.first ?? "",
//                                                reactions: reactionAnswers.map { $0.subtitle ?? ""},
//                                                lowPerformanceItems: lowAnswers.map { $0.subtitle ?? ""},
//                                                highPerformanceItems: highItems.map { $0.valueText })
//            completion(resultItem)
//        }
//    }
//
//    func filteredAnswers(_ answers: [QDMAnswer], filter: DecisionTreeModel.Filter) -> [QDMAnswer] {
//        return answers.filter { $0.keys.filter { $0.contains(filter) }.isEmpty == false }
//    }
//
//    func getHighItems(_ contentItemIDs: [Int], completion: @escaping ([QDMContentItem]) -> Void) {
//        var items: [QDMContentItem] = []
//        let dispatchGroup = DispatchGroup()
//        contentItemIDs.forEach {
//            dispatchGroup.enter()
//            qot_dal.ContentService.main.getContentItemById($0) { (item) in
//                if let item = item, item.searchTags.contains("mindsetshifter-highperformance-item") {
//                    items.append(item)
//                }
//                dispatchGroup.leave()
//            }
//        }
//        dispatchGroup.notify(queue: .main) {
//            completion(items)
//        }
//    }
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
            } else if
                (answer.keys.contains(AnswerKey.Prepare.EventTypeSelectionDaily)
                || answer.keys.contains(AnswerKey.Prepare.EventTypeSelectionCritical)),
                let permissionType = getCalendarPermissionType() {
                    interactor?.presentPermissionView(permissionType)
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
            showNextQuestionIfExist(answer)

        case QuestionKey.Prepare.EventTypeSelectionDaily:
            prepareEventType = answer.subtitle ?? ""
            if let contentId = answer.targetId(.content) {
                showResultView(for: answer, contentID: contentId)
            }

        case QuestionKey.Prepare.BenefitsInput:
            if let contentId = answer.targetId(.content) {
                showResultView(for: answer, contentID: contentId)
            }
        case QuestionKey.Prepare.CalendarEventSelectionCritical,
             QuestionKey.Prepare.CalendarEventSelectionDaily,
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
        case QuestionKey.MindsetShifterTBV.Learn:
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

// MARK: - Recovery
private extension DecisionTreeWorker {
    func handleSelectionRecovery(_ answer: QDMAnswer) {
        recoveryCauseAnswerId = answer.remoteID
        recoveryCauseContentItemId = answer.targetId(.contentItem)
        recoveryCauseContentId = answer.targetId(.content)
        showNextQuestionIfExist(answer)
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
        case QuestionKey.ToBeVision.Instructions:
            if let contentItemID = answer.targetId(.contentItem) {
                interactor?.streamContentItem(with: contentItemID)
            } else if let contentId = answer.targetId(.content) {
                showResultView(for: answer, contentID: contentId)
            }
        default:
            if answer.keys.contains(AnswerKey.ToBeVision.UploadImage) {
                interactor?.openImagePicker()
            }
            showNextQuestionIfExist(answer)
        }
    }
}
