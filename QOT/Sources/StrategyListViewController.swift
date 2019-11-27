//
//  StrategyListViewController.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class StrategyListViewController: BaseWithTableViewController, ScreenZLevel2 {

    // MARK: - Properties

    var interactor: StrategyListInteractorInterface?
    private var lastAudioIndexPath: IndexPath?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didEndAudio(_:)), name: .didEndAudio, object: nil)
        ThemeView.level2.apply(self.view)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusBar(colorMode: ColorMode.dark)
        setStatusBar(color: ThemeView.level2.color)
        trackPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let controller = segue.destination as? ArticleViewController,
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
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 120
        tableView.registerDequeueable(FoundationTableViewCell.self)
        tableView.registerDequeueable(StrategyContentTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
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
    }

    func reload() {
        tableView.allowsSelection = true
        tableView.reloadData()
    }

    func audioPlayStateChangedForCellAt(indexPath: IndexPath) {
        var array: [IndexPath] = [indexPath]
        if let oldIndexPath = lastAudioIndexPath {
            array.append(oldIndexPath)
        }
        lastAudioIndexPath = indexPath
        tableView.reloadRows(at: array, with: UITableViewRowAnimation.none)
    }
}

extension StrategyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = interactor?.rowCount, count > 0 else {
            return 5
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if interactor?.isFoundation == true {
            let cell: FoundationTableViewCell = tableView.dequeueCell(for: indexPath)
            guard interactor?.foundationStrategies.count ?? 0 > indexPath.row,
                    let strategy = interactor?.foundationStrategies[indexPath.item] else {
                cell.configure(title: nil,
                               timeToWatch: nil,
                               imageURL: nil,
                               forcedColorMode: nil)
                return cell
            }

            cell.configure(title: strategy.title,
                           timeToWatch: strategy.durationString,
                           imageURL: strategy.imageURL,
                           forcedColorMode: .dark)
            return cell
        } else {
            let cell: StrategyContentTableViewCell = tableView.dequeueCell(for: indexPath)
            guard interactor?.strategies.count ?? 0 > indexPath.row,
                    let strategy = interactor?.strategies[indexPath.item] else {
                cell.configure(categoryTitle: nil,
                               title: nil,
                               timeToWatch: nil,
                               mediaURL: nil,
                               duration: nil,
                               mediaItemId: nil,
                               delegate: self)
                return cell
            }
            cell.configure(categoryTitle: strategy.categoryTitle,
                           title: strategy.title,
                           timeToWatch: strategy.durationString,
                           mediaURL: strategy.mediaURL,
                           duration: strategy.duration,
                           mediaItemId: strategy.mediaItem?.remoteID,
                           delegate: self)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return StrategyListHeaderView.instantiateFromNib(title: interactor?.headerTitle, theme: .level2)
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if interactor?.isFoundation == true {
            guard
                interactor?.foundationStrategies.count ?? 0 > indexPath.row,
                let foundation = interactor?.foundationStrategies[indexPath.row],
                let videoURL = foundation.mediaURL else { return }
            didSelectRow(at: indexPath)
            trackUserEvent(.OPEN, value: foundation.remoteID, valueType: .CONTENT, action: .TAP)
            let contentItem = foundation.contentItems?.filter({ $0.format == .video }).first
            let playerController = stream(videoURL: videoURL, contentItem: contentItem)
            if playerController == nil {
                tableView.isUserInteractionEnabled = true
                if let selectedRow = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selectedRow, animated: true)
                }
            }
        } else {
            guard interactor?.strategies.count ?? 0 > indexPath.row,
                let strategy = interactor?.strategies[indexPath.item] else {
                    return
            }
            didSelectRow(at: indexPath)
            interactor?.presentArticle(selectedID: strategy.remoteID)
            trackUserEvent(.OPEN, value: strategy.remoteID, valueType: .CONTENT, action: .TAP)
            if AudioPlayer.current.isPlaying == true && AudioPlayer.current.remoteID != strategy.mediaItem?.remoteID {
                trackUserEvent(.STOP, valueType: .AUDIO, action: .TAP)
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

extension StrategyListViewController: IsPlayingDelegate {

    func isPlaying(remoteID: Int?) -> Bool {
        return interactor?.isPlaying(remoteID: remoteID) ?? false
    }
}
