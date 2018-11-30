//
//  TutorialInteractor.swift
//  QOT
//
//  Created by karmic on 16.11.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class TutorialInteractor {

    // MARK: - Properties

    private let worker: TutorialWorker
    private let presenter: TutorialPresenterInterface
    private let router: TutorialRouterInterface

    // MARK: - Init

    init(worker: TutorialWorker,
        presenter: TutorialPresenterInterface,
        router: TutorialRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setup()
    }
}

// MARK: - TutorialInteractorInterface

extension TutorialInteractor: TutorialInteractorInterface {

    var numberOfSlides: Int {
        return worker.numberOfSlides
    }

    func dismiss() {
        router.dismiss()
    }

    func title(at index: Index) -> String? {
        return worker.title(at: index)
    }

    func subtitle(at index: Index) -> String? {
        return worker.subtitle(at: index)
    }

    func body(at index: Index) -> String? {
        return worker.body(at: index)
    }

    func imageURL(at index: Index) -> URL? {
        return worker.imageURL(at: index)
    }

    func attributedbuttonTitle(at index: Index, for origin: TutorialOrigin) -> NSAttributedString {
        return worker.attributedbuttonTitle(at: index, for: origin)
    }
}
