//
//  StrategyListInteractor.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class StrategyListInteractor {

    // MARK: - Properties

    private let worker: StrategyListWorker
    private let presenter: StrategyListPresenterInterface
    private let router: StrategyListRouterInterface
    private var isMediaPlaying = false
    private var remoteID: Int?

    // MARK: - Init

    init(worker: StrategyListWorker,
        presenter: StrategyListPresenterInterface,
        router: StrategyListRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didStartAudio(_:)), name: .didStartAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didPauseAudio(_:)), name: .didPauseAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didStopAudio(_:)), name: .didStopAudio, object: nil)
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - StrategyListInteractorInterface

extension StrategyListInteractor: StrategyListInteractorInterface {

    func isPlaying(remoteID: Int?) -> Bool {
        return self.isMediaPlaying && remoteID == self.remoteID
    }

    var headerTitle: String {
        return worker.headerTitle()
    }

    var isFoundation: Bool {
        return worker.isFoundation
    }

    var rowCount: Int {
        return worker.rowCount
    }

    var foundationStrategies: [Strategy.Item] {
        return worker.foundationStrategies
    }

    var strategies: [Strategy.Item] {
        return worker.strategies
    }

    func presentArticle(selectedID: Int?) {
        router.presentArticle(selectedID: selectedID)
    }

    func reloadData() {
        presenter.reload()
    }

    func selectedStrategyId() -> Int {
        return worker.selectedStrategyId()
    }
}

// FIXME: Refactor all logics in one place
extension StrategyListInteractor {

    @objc func didStartAudio(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel else {
            return
        }
        self.remoteID = mediaModel.mediaRemoteId
        self.isMediaPlaying = true
        if let indexOfTool = strategies.firstIndex(where: {$0.mediaItem?.remoteID == mediaModel.mediaRemoteId}) {
            let intOfIndex = strategies.distance(from: strategies.startIndex, to: indexOfTool)
            presenter.audioPlayStateChangedForCellAt(indexPath: IndexPath(row: intOfIndex, section: 0))
        }
    }

    @objc func didPauseAudio(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel else {
            return
        }
        self.isMediaPlaying = false
        if let indexOfTool = strategies.firstIndex(where: {$0.mediaItem?.remoteID == mediaModel.mediaRemoteId}) {
            let intOfIndex = strategies.distance(from: strategies.startIndex, to: indexOfTool)
            presenter.audioPlayStateChangedForCellAt(indexPath: IndexPath(row: intOfIndex, section: 0))
        }
    }

    @objc func didStopAudio(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel else {
            return
        }
        self.remoteID = nil
        self.isMediaPlaying = false
        if let indexOfTool = strategies.firstIndex(where: {$0.mediaItem?.remoteID == mediaModel.mediaRemoteId}) {
            let intOfIndex = strategies.distance(from: strategies.startIndex, to: indexOfTool)
            presenter.audioPlayStateChangedForCellAt(indexPath: IndexPath(row: intOfIndex, section: 0))
        }
    }
}
