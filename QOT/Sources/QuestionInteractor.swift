//
//  QuestionInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class QuestionInteractor {

    // MARK: - Properties

    private let worker: QuestionWorker
    private let presenter: QuestionPresenterInterface
    private let router: QuestionRouterInterface

    // MARK: - Init

    init(worker: QuestionWorker,
         presenter: QuestionPresenterInterface,
         router: QuestionRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
    }
}

// MARK: - QuestionInteractorInterface

extension QuestionInteractor: QuestionInteractorInterface {

    func randomQuestion(completion: @escaping ((String?) -> Void)) {
        return worker.randomQuestion(completion: completion)
    }
}
