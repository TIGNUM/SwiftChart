//
//  AskPermissionInteractor.swift
//  QOT
//
//  Created by karmic on 26.08.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class AskPermissionInteractor {

    // MARK: - Properties
    private let worker: AskPermissionWorker
    private let presenter: AskPermissionPresenterInterface
    private let router: AskPermissionRouterInterface

    // MARK: - Init
    init(worker: AskPermissionWorker,
         presenter: AskPermissionPresenterInterface,
         router: AskPermissionRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        worker.getPermissionContent { [weak self] (contentCollection, type) in
            self?.presenter.setupView(contentCollection, type: type)
        }
    }
}

// MARK: - AskPermissionInteractorInterface
extension AskPermissionInteractor: AskPermissionInteractorInterface {
    var permissionType: AskPermission.Kind {
        return worker.getPermissionType
    }

    var placeholderImage: UIImage? {
        let image: UIImage?
        switch worker.getPermissionType {
        default: image = R.image.preloading()
        }
        return image
    }

    func didTapSkip() {
        router.didTapDismiss(worker.getPermissionType)
    }

    func didTapConfirm() {
        router.didTapConfirm(worker.getPermissionType)
    }
}
