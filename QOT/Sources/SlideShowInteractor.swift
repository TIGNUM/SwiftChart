//
//  SlideShowInteractor.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SlideShowInteractor {

    private let worker: SlideShowWorker
    private let presenter: SlideShowPresenterInterface
    private let router: SlideShowRouterInterface

    init(worker: SlideShowWorker, presenter: SlideShowPresenterInterface, router: SlideShowRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }
}

// MARK: - SlideShowInteractorInterface

extension SlideShowInteractor: SlideShowInteractorInterface {

    func viewDidLoad() {
        presenter.loadSlideShow(slides: worker.slides())
    }

    func didTapDone() {
        router.dismissSlideShow()
    }
}
