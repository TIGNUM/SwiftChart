//
//  GuideInteractor.swift
//  QOT
//
//  Created by Sam Wyndham on 24/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class GuideInteractor: GuideInteractorInterface {

    let presenter: GuidePresenterInterface
    let guideObserver: GuideObserver
    let worker: GuideWorker

    init(presenter: GuidePresenterInterface, guideObserver: GuideObserver, worker: GuideWorker) {
        self.guideObserver =  guideObserver
        self.worker = worker
        self.presenter = presenter

        guideObserver.guideDidChange = { [unowned self] in
            self.reload()
        }
    }

    func viewDidLoad() {
        presenter.presentLoading()
        reload()
    }

    func reload() {
        worker.makeGuide { [weak self] (guide) in
            if let guide = guide {
                let imageResource = worker.services.userService.myToBeVision()?.profileImageResource
                if let localImageURL = imageResource?.localURL {
                    self?.presenter.present(model: guide, headerImage: localImageURL)
                    return
                }
                self?.presenter.present(model: guide, headerImage: imageResource?.remoteURL)
            } else {
                self?.presenter.presentLoading()
            }
        }
    }

    func didTapItem(_ item: Guide.Item) {
        guard item.isDailyPrep == false,
            item.status == .todo,
            let id = try? GuideItemID(stringRepresentation: item.identifier) else { return }

        worker.setItemCompleted(id: id)
    }
}
