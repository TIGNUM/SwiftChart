//
//  DTMindsetViewController.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTMindsetViewController: DTViewController {

    // MARK: - Properties
    var mindsetRouter: DTMindsetRouterInterface?
    var mindsetInteractor: DTMindsetInteractorInterface?

    // MARK: - Init
    init(configure: Configurator<DTMindsetViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DTViewController
    override func getAnswerFilter(selectedAnswers: [DTViewModel.Answer], questionKey: String?) -> String? {
        let firstAnswer = selectedAnswers.first
        switch questionKey {
        case Mindset.QuestionKey.Intro?:
            return firstAnswer?.keys.filter { $0.contains(Mindset.Filter.Relationship) }.first
        case Mindset.QuestionKey.MoreInfo?:
            var tempTitle = firstAnswer?.title.replacingOccurrences(of: " ", with: "_") ?? ""
            tempTitle = tempTitle.replacingOccurrences(of: "\'", with: "")
            return Mindset.Filter.TriggerRelationship + tempTitle
        case Mindset.QuestionKey.GutReactions?:
            return firstAnswer?.keys.filter { $0.contains(Mindset.Filter.Relationship) }.first
        default:
            return nil
        }
    }

    @IBAction override func didTapNext() {
        switch viewModel?.question.key {
        case Mindset.QuestionKey.Last:
            mindsetRouter?.dismiss()
        case Mindset.QuestionKey.OpenTBV:
            handleTBVCase()
        case Mindset.QuestionKey.PresentResult:
            presentMindsetShifterResult()
        default:
            setAnswerNeedsSelection()
            loadNextQuestion()
        }
    }

    // MARK: - DTQuestionnaireViewControllerDelegate
    override func didTapBinarySelection(_ answer: DTViewModel.Answer) {
        super.didTapBinarySelection(answer)
    }

    override func didSelectAnswer(_ answer: DTViewModel.Answer) {
        viewModel?.setSelectedAnswer(answer)
        guard let viewModel = viewModel else { return }
        if viewModel.question.answerType == .singleSelection && answer.targetId(.question) != nil {
            loadNextQuestion()
        }
    }

    override func didDeSelectAnswer(_ answer: DTViewModel.Answer) {
        viewModel?.setSelectedAnswer(answer)
    }
}

// MARK: - Private
private extension DTMindsetViewController {
    func handleTBVCase() {
        mindsetInteractor?.getUsersTBV { [weak self] (tbv, initiated) in
            if initiated && tbv?.text != nil {
                let targetAnswer = self?.getAnswerToSelect(Mindset.AnswerKey.ShowTBV)
                self?.setAnswerNeedsSelection(targetAnswer)
                self?.loadNextQuestion()
            } else {
                self?.mindsetRouter?.loadShortTBVGenerator(introKey: ShortTBV.QuestionKey.IntroMindSet,
                                                           delegate: self?.mindsetInteractor) { [weak self] in
                                                            let targetAnswer = self?.getAnswerToSelect(Mindset.AnswerKey.CheckPlan)
                                                            self?.setAnswerNeedsSelection(targetAnswer)
                                                            self?.loadNextQuestion()
                }
            }
        }
    }

    func presentMindsetShifterResult() {
        mindsetInteractor?.getMindsetShifter { [weak self] (mindsetShifter) in
            self?.mindsetRouter?.presentMindsetResults(mindsetShifter) {
                self?.setAnswerNeedsSelection()
                self?.loadNextQuestion()
            }
        }
    }

    func getAnswerToSelect(_ answerKey: String) -> DTViewModel.Answer? {
        return viewModel?.answers.filter { $0.keys.contains(answerKey) }.first
    }
}
