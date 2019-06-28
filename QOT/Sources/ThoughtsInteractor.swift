//
//  ThoughtsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//
import qot_dal
import UIKit

final class ThoughtsInteractor {

    // MARK: - Properties

    private let worker: ThoughtsWorker
    private let presenter: ThoughtsPresenterInterface
    private let router: ThoughtsRouterInterface

    // MARK: - Init

    init(worker: ThoughtsWorker,
         presenter: ThoughtsPresenterInterface,
         router: ThoughtsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
    }
}

// MARK: - ThoughtsInteractorInterface

extension ThoughtsInteractor: ThoughtsInteractorInterface {

    func listOfThoughts(completion: @escaping (([String?]) -> Void)) {
        return worker.listOfThoughts(completion: completion)
    }

    func listOfAuthors(completion: @escaping (([String?]) -> Void)) {
        return worker.listOfAuthors(completion: completion)
    }
}
