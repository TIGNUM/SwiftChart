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
    override func getAnswerFilter(selectedAnswer: DTViewModel.Answer?, questionKey: String?) -> String? {
        switch questionKey {
        case Mindset.QuestionKey.Intro?:
            return selectedAnswer?.keys.filter { $0.contains(Mindset.Filter.Relationship) }.first
        case Mindset.QuestionKey.MoreInfo?:
            var tempTitle = selectedAnswer?.title.replacingOccurrences(of: " ", with: "_") ?? ""
            tempTitle = tempTitle.replacingOccurrences(of: "\'", with: "")
            return Mindset.Filter.TriggerRelationship + tempTitle
        case Mindset.QuestionKey.GutReactions?:
            return selectedAnswer?.keys.filter { $0.contains(Mindset.Filter.Relationship) }.first
        default:
            return nil
        }
    }

    @IBAction override func didTapNext() {
        switch viewModel?.question.key {
        case Mindset.QuestionKey.OpenTBV:
            handleTBVCase()
        case Mindset.QuestionKey.PresentResult:
            mindsetInteractor?.generateMindsetResults()
            mindsetRouter?.presentMindsetResults()
        default:
            setAnswerSelectedIfNeeded()
            loadNextQuestion()
        }        
    }

    // MARK: - DTQuestionnaireViewControllerDelegate
    override func didTapBinarySelection(_ answer: DTViewModel.Answer) {

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

// MARK: - Actions
private extension DTMindsetViewController {
    /**
     An answer contains the decision about the next question to load or needed content.
     Some questions will be displayed without answers. If the an answer can not be
     selected by the user, the selection will happen here on `didTapNext()`.

     - Parameter answer: The answer to select if exist otherwise select first available.
     */
    func setAnswerSelectedIfNeeded(_ answer: DTViewModel.Answer? = nil) {
        switch viewModel?.question.key {
        case Mindset.QuestionKey.LowSelfTalk?:
            if var answer = viewModel?.answers.first {
                answer.setSelected(true)
                viewModel?.setSelectedAnswer(answer)
            }
        default: break
        }
    }

    func handleTBVCase() {
        if true {
            mindsetRouter?.loadShortTBVGenerator(introKey: ShortTBV.QuestionKey.IntroMindSet,
                                                 delegate: mindsetInteractor) { [weak self] in
                                                    self?.loadNextQuestion()
            }
        } else {
            interactor?.getUsersTBV { [weak self] (tbv, initiated) in
                if initiated && tbv?.text != nil {
                    let targetAnswer = self?.getAnswerToSelect(Mindset.AnswerKey.ShowTBV)
                    self?.setAnswerSelectedIfNeeded(targetAnswer)
                    self?.loadNextQuestion()
                } else {
                    self?.mindsetRouter?.loadShortTBVGenerator(introKey: ShortTBV.QuestionKey.IntroMindSet,
                                                               delegate: self?.mindsetInteractor) { [weak self] in
                                                                let targetAnswer = self?.getAnswerToSelect(Mindset.AnswerKey.CheckPlan)
                                                                self?.setAnswerSelectedIfNeeded(targetAnswer)
                                                                self?.loadNextQuestion()
                    }
                }
            }
        }
    }

    func getAnswerToSelect(_ answerKey: String) -> DTViewModel.Answer? {
        return viewModel?.answers.filter { $0.keys.contains(answerKey) }.first
    }
}
