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
	var currentGuide: Guide.Model?
    var reloadRequestCount: Int = 0

    init(presenter: GuidePresenterInterface, guideObserver: GuideObserver, worker: GuideWorker) {
        self.guideObserver =  guideObserver
        self.worker = worker
        self.presenter = presenter

        guideObserver.guideDidChange = { [unowned self] in
            if self.reloadRequestCount == 0 {
                self.reload()
            }
            self.reloadRequestCount += 1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                if self.reloadRequestCount > 1 {
                    self.reload()
                }
                self.reloadRequestCount = 0
            }
        }
    }

    func viewDidLoad() {
        presenter.presentLoading()
        reload()
    }

	func reload() {
		worker.makeGuide { [weak self] (guide) in
			if guide != nil {
				self?.currentGuide = guide
				self?.presentGuideWithImage()
			} else {
				self?.presenter.presentLoading()
			}
		}
	}

	func presentGuideWithImage() {
		guard let guide = currentGuide else { return }
		let imageResource = worker.services.userService.myToBeVision()?.profileImageResource
		presenter.present(model: guide, headerImage: imageResource?.localURL ?? imageResource?.remoteURL)
	}

	func didTapItem(_ item: Guide.Item) {
		guard
			item.isDailyPrep == false,
			item.status == .todo,
			let id = try? GuideItemID(stringRepresentation: item.identifier) else { return }
		worker.setItemCompleted(id: id)
	}

    func didTapWhatsHotItem(_ item: Guide.Item) {
        worker.markWhatsHotRead(item: item)
    }
}
