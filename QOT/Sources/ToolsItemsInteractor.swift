//
//  ToolsItemsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ToolsItemsInteractor {

    // MARK: - Properties

    private let worker: ToolsItemsWorker
    private let presenter: ToolsItemsPresenterInterface
    private var isMediaPlaying = false

    // MARK: - Init

    init(worker: ToolsItemsWorker,
         presenter: ToolsItemsPresenterInterface) {
        self.worker = worker
        self.presenter = presenter
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didStartAudio(_:)), name: .didStartAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didPauseAudio(_:)), name: .didPauseAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didStopAudio(_:)), name: .didStopAudio, object: nil)
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
        worker.load { [weak self] in
            self?.presenter.reload()
        }
    }
}

// MARK: - ToolsInteractorInterface

extension ToolsItemsInteractor: ToolsItemsInteractorInterface {

    var isPlaying: Bool {
        return self.isMediaPlaying
    }

    var headerTitle: String {
        return worker.headerTitle
    }

    var headerSubtitle: String {
        return worker.headerSubtitle
    }

    var tools: [Tool.Item] {
        return worker.tools
    }

    var rowCount: Int {
        return worker.tools.count
    }

    func selectedContentId() -> Int {
        return worker.selectedContentId()
    }
}

extension ToolsItemsInteractor {

    @objc func didStartAudio(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel else {
            return
        }
        self.isMediaPlaying = true
        let indexOfTool = tools.firstIndex(where: {$0.remoteID == mediaModel.mediaRemoteId})
        let intOfIndex = tools.distance(from: tools.startIndex, to: indexOfTool ?? 0)
        presenter.audioIsPlayingForCell(index: IndexPath(row: intOfIndex, section: 0))
    }

    @objc func didPauseAudio(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel else {
            return
        }
        self.isMediaPlaying = false
        let indexOfTool = tools.firstIndex(where: {$0.remoteID == mediaModel.mediaRemoteId})
        let intOfIndex = tools.distance(from: tools.startIndex, to: indexOfTool ?? 0)
        presenter.audioIsPlayingForCell(index: IndexPath(row: intOfIndex, section: 0))
    }

    @objc func didStopAudio(_ notification: Notification) {
        guard let mediaModel = notification.object as? MediaPlayerModel else {
            return
        }
        self.isMediaPlaying = false
        let indexOfTool = tools.firstIndex(where: {$0.remoteID == mediaModel.mediaRemoteId})
        let intOfIndex = tools.distance(from: tools.startIndex, to: indexOfTool ?? 0)
        presenter.audioIsPlayingForCell(index: IndexPath(row: intOfIndex, section: 0))
    }
}
