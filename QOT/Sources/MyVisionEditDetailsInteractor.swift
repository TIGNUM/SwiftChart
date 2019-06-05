//
//  MyVisionEditDetailsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyVisionEditDetailsInteractor {
    let presenter: MyVisionEditDetailsPresenterInterface
    let worker: MyVisionEditDetailsWorker

    init(presenter: MyVisionEditDetailsPresenterInterface,
         worker: MyVisionEditDetailsWorker) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension MyVisionEditDetailsInteractor: MyVisionEditDetailsInteractorInterface {

    var firstTimeUser: Bool {
        return worker.firstTimeUser
    }

    var myVision: QDMToBeVision? {
        return worker.myVision
    }

    var originalTitle: String {
        return worker.originalTitle
    }

    var originalVision: String {
        return worker.originalVision
    }

    func updateMyToBeVision(_ toBeVision: QDMToBeVision, _ completion: @escaping (Error?) -> Void) {
        worker.updateMyToBeVision(toBeVision) { (error) in
            completion(error)
        }
    }

    func formatPlaceholder(title: String) -> NSAttributedString? {
        return worker.formatPlaceholder(title: title)
    }

    func format(title: String) -> NSAttributedString? {
        return worker.format(title: title)
    }

    func formatPlaceholder(vision: String) -> NSAttributedString? {
        return worker.formatPlaceholder(vision: vision)
    }

    func format(vision: String) -> NSAttributedString? {
        return worker.format(vision: vision)
    }

    func viewDidLoad() {
        presenter.setupView(title: originalTitle, vision: originalVision)
    }
}
