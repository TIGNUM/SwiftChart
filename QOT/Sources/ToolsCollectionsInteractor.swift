//
//  ToolsCollectionsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ToolsCollectionsInteractor {

    // MARK: - Properties

    private let worker: ToolsCollectionsWorker
    private let presenter: ToolsCollectionsPresenterInterface
    private let router: ToolsCollectionsRouterInterface

    // MARK: - Init
    private var toolItems = [Tool.Item]()
    private var videoToolItems = [Tool.Item]()
    private var isMediaPlaying = false

    init(worker: ToolsCollectionsWorker,
         presenter: ToolsCollectionsPresenterInterface,
         router: ToolsCollectionsRouterInterface) {
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
        worker.tools { [weak self] tools in
            self?.toolItems = tools
            self?.worker.videoTools({ (videos) in
                self?.videoToolItems = videos
                self?.presenter.reload()
            })
        }
    }
}

// MARK: - ToolsInteractorInterface

extension ToolsCollectionsInteractor: ToolsCollectionsInteractorInterface {

    var isPlaying: Bool {
        return self.isMediaPlaying
    }

    var headerTitle: String {
        return worker.headerTitle
    }

    var tools: [Tool.Item] {
        return toolItems
    }

    var videoTools: [Tool.Item] {
        return videoToolItems
    }

    var rowCount: Int {
        return toolItems.count
    }

    func presentToolsItems(selectedToolID: Int?) {
        return router.presentToolsItems(selectedToolID: selectedToolID)
    }

    func selectedCategoryId() -> Int {
        return worker.selectedCategoryId()
    }

    func contentItem(for id: Int, _ completion: @escaping (QDMContentItem?) -> Void) {
        return worker.contentItem(for: id, completion)
    }
}

extension ToolsCollectionsInteractor {

    @objc func didStartAudio(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel else {
            return
        }
        self.isMediaPlaying = true
        let indexOfTool = tools.firstIndex(where: {$0.remoteID == mediaModel.mediaRemoteId})
        let intOfIndex = tools.distance(from: tools.startIndex, to: indexOfTool ?? 0)
        presenter.audioPlayStateChangedForCellAt(indexPath: IndexPath(row: intOfIndex, section: 0))
    }

    @objc func didPauseAudio(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel else {
            return
        }
        self.isMediaPlaying = false
        let indexOfTool = tools.firstIndex(where: {$0.remoteID == mediaModel.mediaRemoteId})
        let intOfIndex = tools.distance(from: tools.startIndex, to: indexOfTool ?? 0)
        presenter.audioPlayStateChangedForCellAt(indexPath: IndexPath(row: intOfIndex, section: 0))
    }

    @objc func didStopAudio(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel else {
            return
        }
        self.isMediaPlaying = false
        let indexOfTool = tools.firstIndex(where: {$0.remoteID == mediaModel.mediaRemoteId})
        let intOfIndex = tools.distance(from: tools.startIndex, to: indexOfTool ?? 0)
        presenter.audioPlayStateChangedForCellAt(indexPath: IndexPath(row: intOfIndex, section: 0))
    }
}
