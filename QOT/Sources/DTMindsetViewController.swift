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
    private var tbv: QDMToBeVision?

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

    override func getUsersTBV() -> QDMToBeVision? {
        return tbv
    }

    @IBAction override func didTapNext() {
        setSelectedAnswerIfNeeded()
        if viewModel?.question.key == Mindset.QuestionKey.OpenTBV {
            interactor?.getUsersTBV { [weak self] (tbv, initiated) in
                if initiated && tbv?.text != nil {
                    self?.tbv = tbv
                    self?.loadNextQuestion()
                } else {
                    self?.router?.openTBVGenerator()
                }
            }
        } else {
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
        } else if viewModel.question.answerType == .singleSelection && answer.targetId(.content) != nil {
//            presentContentView(selectedAnswer: answer)
        }
    }

    override func didDeSelectAnswer(_ answer: DTViewModel.Answer) {
        viewModel?.setSelectedAnswer(answer)
    }
}

// MARK: - Actions
private extension DTMindsetViewController {
    func setSelectedAnswerIfNeeded() {
        switch viewModel?.question.key {
        case Mindset.QuestionKey.LowSelfTalk?,
             Mindset.QuestionKey.OpenTBV?:
            if var answer = viewModel?.answers.first {
                answer.setSelected(true)
                viewModel?.setSelectedAnswer(answer)
            }
        default: break
        }
    }
}
