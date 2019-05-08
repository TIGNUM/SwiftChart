//
//  DecisionTreeInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DecisionTreeInteractor {

    // MARK: - Properties

    private let worker: DecisionTreeWorker
    private let presenter: DecisionTreePresenterInterface
    private let router: DecisionTreeRouterInterface

    // MARK: - Init

    init(worker: DecisionTreeWorker,
         presenter: DecisionTreePresenterInterface,
         router: DecisionTreeRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        loadScene()
    }
}

// MARK: - DecisionTreeInteractorInterface

extension DecisionTreeInteractor: DecisionTreeInteractorInterface {

    func loadNextQuestion(from targetID: Int, selectedAnswers: [Answer]) {
        let node = worker.fetchNextQuestion(from: targetID, selectedAnswers: selectedAnswers)
        if let question = node.question {
            presenter.presentNext(question, with: node.extraAnswer)
        }
    }

    func displayContent(with id: Int) {
        router.openArticle(with: id)
    }

    func streamContentItem(with id: Int) {
        if let url = worker.mediaURL(from: id) {
            router.openVideo(from: url)
        }
    }

    func uploadPhoto() {
        router.openImagePicker()
    }
}

// MARK: - Private

private extension DecisionTreeInteractor {

    func loadScene() {
        if let firstQuestion = worker.fetchFirstQuestion() {
            let decisionTree = DecisionTreeModel(questions: [firstQuestion], selectedAnswers: [])
            presenter.load(decisionTree)
        }
    }
}
