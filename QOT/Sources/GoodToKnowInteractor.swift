//
//  GoodToKnowInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 25.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import qot_dal
import UIKit

final class GoodToKnowInteractor {

    // MARK: - Properties

    private let worker: GoodToKnowWorker
    private let presenter: GoodToKnowPresenterInterface
    private let router: GoodToKnowRouterInterface

    // MARK: - Init

    init(worker: GoodToKnowWorker,
         presenter: GoodToKnowPresenterInterface,
         router: GoodToKnowRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
    }
}

// MARK: - GoodToKnowInteractorInterface

extension  GoodToKnowInteractor:  GoodToKnowInteractorInterface {

    func listOfFacts(completion: @escaping (([String?]) -> Void)) {
        return worker.listOfFacts(completion: completion)
    }

    func listOfPictures(completion: @escaping (([String?]) -> Void)) {
        return worker.listOfPictures(completion: completion)
    }}
