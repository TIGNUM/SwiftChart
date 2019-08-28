//
//  StrategyListViewController.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import qot_dal

final class StrategyListViewController: UIViewController, ScreenZLevel2 {

    // MARK: - Properties

    var interactor: StrategyListInteractorInterface?
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didEndAudio(_:)), name: .didEndAudio, object: nil)
        ThemeView.level2.apply(self.view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(colorMode: ColorMode.dark)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let controller = (segue.destination as? UINavigationController)?.viewControllers.first as? ArticleViewController,
            let selectedID = sender as? Int {
            ArticleConfigurator.configure(selectedID: selectedID, viewController: controller)
        }
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 0
        pageTrack.pageKey = pageKey
        pageTrack.associatedValueType = .CONTENT_CATEGORY
        pageTrack.associatedValueId = interactor?.selectedStrategyId()
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

// MARK: - Private

private extension StrategyListViewController {
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.registerDequeueable(FoundationTableViewCell.self)
        tableView.registerDequeueable(StrategyContentTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Bottom Navigation
extension StrategyListViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [backNavigationItem()]
    }
}

// MARK: - StrategyListViewControllerInterface

extension StrategyListViewController: StrategyListViewControllerInterface {
    func setupView() {
        setupTableView()
        self.showLoadingSkeleton(with: [.oneLineHeading, .twoLinesAndImage, .twoLinesAndImage, .twoLinesAndImage, .twoLinesAndImage, .twoLinesAndImage])
    }

    func reload() {
        tableView.reloadData()
        self.removeLoadingSkeleton()
    }
}

extension StrategyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.rowCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if interactor?.isFoundation == true {
            let strategy = interactor?.foundationStrategies[indexPath.item]
            let cell: FoundationTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: strategy?.title ?? "",
                           timeToWatch: strategy?.durationString ?? "",
                           imageURL: strategy?.imageURL)
            return cell
        } else {
            let strategy = interactor?.strategies[indexPath.item]
            let cell: StrategyContentTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(categoryTitle: strategy?.categoryTitle ?? "",
                           title: strategy?.title ?? "",
                           timeToWatch: strategy?.durationString ?? "",
                           mediaURL: strategy?.mediaURL,
                           duration: strategy?.duration ?? 0,
                           mediaItemId: strategy?.mediaItem?.remoteID ?? 0)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return StrategyListHeaderView.instantiateFromNib(title: interactor?.headerTitle ?? "", theme: .level2)
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 76
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if interactor?.isFoundation == true {
            guard
                let foundation = interactor?.foundationStrategies[indexPath.row],
                let videoURL = foundation.mediaURL else { return }
            trackUserEvent(.OPEN, value: foundation.remoteID, valueType: .CONTENT, action: .TAP)
            let contentItem = foundation.contentItems?.filter({ $0.format == .video }).first
            stream(videoURL: videoURL, contentItem: contentItem) // TODO Set correct pageName
        } else {
            let strategy = interactor?.strategies[indexPath.item]
            interactor?.presentArticle(selectedID: strategy?.remoteID)
            trackUserEvent(.OPEN, value: strategy?.remoteID, valueType: .CONTENT, action: .TAP)
            if AudioPlayer.current.isPlaying == true && AudioPlayer.current.remoteID != strategy?.mediaItem?.remoteID {
                NotificationCenter.default.post(name: .stopAudio, object: nil)
            }
        }
    }
}

// MARK: - Audio Player Related
extension StrategyListViewController {
    @objc func didEndAudio(_ notification: Notification) {
        tableView.reloadData()
    }
}
