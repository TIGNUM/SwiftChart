//
//  TrackSelectionInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class TrackSelectionInteractor {

    // MARK: - Properties

    private let worker: TrackSelectionWorker
    private let presenter: TrackSelectionPresenterInterface
    private let router: TrackSelectionRouterInterface
    let type: TrackSelectionControllerType

    // MARK: - Init

    init(worker: TrackSelectionWorker,
        presenter: TrackSelectionPresenterInterface,
        router: TrackSelectionRouterInterface,
        type: TrackSelectionControllerType) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.type = type
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }

    // MARK: - Texts

    var title: String {
        return worker.title
    }

    var descriptionText: String {
        return worker.descriptionText
    }

    var fastTrackButton: String {
        return worker.fastTrackButton
    }

    var guidedTrackButton: String {
        return worker.guidedTrackButton
    }
}

// MARK: - TrackSelectionInteractorInterface

extension TrackSelectionInteractor: TrackSelectionInteractorInterface {

    func askNotificationPermissions() {
        worker.notificationRequestType { [weak self] (type) in
            guard let type = type else { return }
            self?.router.showNotificationPersmission(type: type, completion: nil)
        }
    }

    func didTapFastTrack() {
        worker.guideTrackBucketVisible(false)
        router.openWalktrough(with: .fast)
    }

    func didTapGuidedTrack() {
        worker.guideTrackBucketVisible(true)
        router.openWalktrough(with: .guided)
    }
}
