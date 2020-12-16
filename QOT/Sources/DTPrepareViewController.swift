//
//  DTPrepareViewController.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import qot_dal

final class DTPrepareViewController: DTViewController {

    // MARK: - Properties
    weak var delegate: ResultsPrepareViewControllerInterface?
    var prepareInteractor: DTPrepareInteractor!
    var prepareRouter: DTPrepareRouterInterface?
    private var answerFilter: String?

    // MARK: - Init
    init(configure: Configurator<DTPrepareViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Answer Handling
    override func didTapClose() {
        if delegate != nil {
            prepareRouter?.dismissResultView()
            trackQuestionInteraction()
        } else {
            super.didTapClose()
        }
    }

    override func didTapNext() {
        if delegate != nil {
            if viewModel?.question.key == Prepare.QuestionKey.BenefitsInput {
                delegate?.didUpdateBenefits(prepareInteractor?.inputText ?? "")
                prepareRouter?.dismissResultView()
            } else {
                let answerIds = viewModel?.selectedAnswers.compactMap { $0.remoteId } ?? []
                delegate?.didUpdateIntentions(answerIds)
                prepareRouter?.dismissResultView()
            }
            return
        }

        //multi-select and OK buttons call the same 'setAnswerNeedsSelection' method, this always selects answer[0]
        setAnswerNeedsSelectionIfNoOtherAnswersAreSelectedAlready()
        switch viewModel?.question.key {
        case Prepare.QuestionKey.BenefitsInput?:
            createPreparationAndPresent()
        default:
            loadNextQuestion()
        }
    }

    override func didSelectAnswer(_ answer: DTViewModel.Answer) {
        setSelectedAnswer(answer)
        if viewModel?.question.answerType == .singleSelection {
            if answer.targetId(.content) != nil {
                handleAnswerSelection(answer)
            } else {
                switch viewModel?.question.key {
                case Prepare.QuestionKey.BuildCritical?:
                    handleTBVSelection(answer)
                default:
                    loadNextQuestion()
                }
            }
        }
    }

    override func didSelectExistingPreparation(_ qdmPreparation: QDMUserPreparation?) {
        super.didSelectExistingPreparation(qdmPreparation)
        prepareInteractor.createUserPreparation(from: qdmPreparation) { [weak self] (createdQDMPreparation) in
            self?.prepareRouter?.presentPrepareResults(createdQDMPreparation)
        }
    }

    override func getAnswerFilter(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        if questionKey == Prepare.QuestionKey.EventTypeSelectionCritical {
            answerFilter = selectedAnswers.flatMap { $0.keys }.filter { $0.contains(Prepare.AnswerFilter) }.first
        }
        switch questionKey {
        case Prepare.QuestionKey.ShowTBV?,
             Prepare.Key.know.rawValue?,
             Prepare.Key.perceived.rawValue?,
             Prepare.Key.eventType.rawValue?:
            return answerFilter
        default:
            return nil
        }
    }

    override func updateView(viewModel: DTViewModel) {
        super.updateView(viewModel: viewModel)
        closeButton.isHidden = (viewModel.question.key == Prepare.QuestionKey.BenefitsInput)
    }
}

// MARK: - Private
private extension DTPrepareViewController {
    func handleAnswerSelection(_ answer: DTViewModel.Answer) {
        if answer.keys.contains(Prepare.AnswerKey.KindOfEventSelectionDaily) {
            prepareInteractor.getUserPreparationDaily(answer: answer) { [weak self] (preparation) in
                self?.prepareRouter?.presentPrepareResults(preparation)
            }
        } else {
            loadNextQuestion()
        }
    }

    func handleTBVSelection(_ answer: DTViewModel.Answer) {
        prepareInteractor?.getUsersTBV { [weak self] (tbv, initiated) in
            if initiated && tbv?.text != nil {
                self?.loadNextQuestion()
            } else {
                self?.prepareRouter?.loadShortTBVGenerator(introKey: ShortTBV.QuestionKey.IntroPrepare,
                                                           delegate: self?.prepareInteractor) { [weak self] in
                                                            let targetId = Prepare.QuestionTargetId.IntentionPerceived
                                                            let targetAnswer = DTViewModel.Answer(answer: answer,
                                                                                                  newTargetId: targetId,
                                                                                                  votes: 0)
                                                            self?.setAnswerNeedsSelection(targetAnswer)
                                                            self?.loadNextQuestion(answerFilter: self?.answerFilter)
                }
            }
        }
    }

    func createPreparationAndPresent() {
        prepareInteractor.getUserPreparationCritical(answerFilter: answerFilter ?? "") { [weak self] (preparation) in
            self?.prepareRouter?.presentPrepareResults(preparation)
        }
    }

    func resetSelectedAnswers() {
        if let viewModel = viewModel {
            viewModel.resetSelectedAnswers()
            showQuestion(viewModel: viewModel, direction: .forward, animated: false)
        }
    }
}
