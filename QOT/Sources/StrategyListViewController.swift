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

protocol AudioPlayerViewDelegate: class {
    func didTabPlayPause(categoryTitle: String, title: String, audioURL: URL?, remoteID: Int)
    func didTabClose(for view: AudioPlayer.View)
    func didFinishAudio()
    func openFullScreen()
}

final class StrategyListViewController: UIViewController, ScreenZLevel2 {

    // MARK: - Properties

    var interactor: StrategyListInteractorInterface?
    @IBOutlet private weak var tableView: UITableView!
    private var audioPlayerBar = AudioPlayerBar()
    private var audioPlayerFullScreen = AudioPlayerFullScreen()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBar(colorMode: ColorMode.dark)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let controller = (segue.destination as? UINavigationController)?.viewControllers.first as? ArticleViewController,
            let selectedID = sender as? Int {
            ArticleConfigurator.configure(selectedID: selectedID, viewController: controller)
        }
    }
}

// MARK: - Private

private extension StrategyListViewController {
    func setupTableView() {
        tableView.registerDequeueable(FoundationTableViewCell.self)
        tableView.registerDequeueable(StrategyContentTableViewCell.self)
        tableView.tableFooterView = UIView()
    }

    func setupAudioPlayerView() {
        audioPlayerBar = AudioPlayerBar.instantiateFromNib()
        view.addSubview(audioPlayerBar)
        audioPlayerBar.trailingAnchor == view.trailingAnchor
        audioPlayerBar.leadingAnchor == view.leadingAnchor
        audioPlayerBar.bottomAnchor == view.bottomAnchor - 24
        audioPlayerBar.heightAnchor == 40
        audioPlayerBar.layoutIfNeeded()
        audioPlayerBar.isHidden = true
        audioPlayerBar.viewDelegate = self
    }
}

// MARK: - StrategyListViewControllerInterface

extension StrategyListViewController: StrategyListViewControllerInterface {
    func setupView() {
        view.backgroundColor = .carbon
        setupTableView()
        setupAudioPlayerView()
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
            cell.viewDelegate = self
            cell.configure(categoryTitle: strategy?.categoryTitle ?? "",
                           title: strategy?.title ?? "",
                           timeToWatch: strategy?.durationString ?? "",
                           mediaURL: strategy?.mediaURL,
                           duration: strategy?.duration ?? 0,
                           remoteID: strategy?.remoteID ?? 0)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return StrategyListHeaderView.instantiateFromNib(title: interactor?.headerTitle ?? "")
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
            stream(videoURL: videoURL, contentItem: nil, pageName: PageName.learnContentItemFull) // TODO Set correct pageName
        } else {
            let strategy = interactor?.strategies[indexPath.item]
            interactor?.presentArticle(selectedID: strategy?.remoteID)
            trackUserEvent(.OPEN, value: strategy?.remoteID, valueType: .CONTENT, action: .TAP)
            if AudioPlayer.current.isPlaying == true && AudioPlayer.current.remoteID != strategy?.remoteID {
                AudioPlayer.current.resetPlayer()
                didTabClose(for: .bar)
            }
        }
    }
}

// MARK: - AudioPlayerViewDelegate

extension StrategyListViewController: AudioPlayerViewDelegate {
    func didTabClose(for view: AudioPlayer.View) {
        switch view {
        case .bar:
            audioPlayerBar.isHidden = true
        case .fullScreen:
            audioPlayerBar.updateView()
            audioPlayerFullScreen.animateHidden(true)
        }
    }

    func didTabPlayPause(categoryTitle: String, title: String, audioURL: URL?, remoteID: Int) {
        if audioPlayerBar.isHidden == true {
            audioPlayerBar.isHidden = false
        }
        audioPlayerBar.configure(categoryTitle: categoryTitle,
                                 title: title,
                                 audioURL: audioURL,
                                 remoteID: remoteID)
    }

    func didFinishAudio() {
        tableView.reloadData()
    }

    func openFullScreen() {
        audioPlayerFullScreen = AudioPlayerFullScreen.instantiateFromNib()
        audioPlayerFullScreen.viewDelegate = self
        audioPlayerFullScreen.isHidden = true
        view.addSubview(audioPlayerFullScreen)
        audioPlayerFullScreen.topAnchor == view.topAnchor
        audioPlayerFullScreen.bottomAnchor == view.bottomAnchor
        audioPlayerFullScreen.trailingAnchor == view.trailingAnchor
        audioPlayerFullScreen.leadingAnchor == view.leadingAnchor
        audioPlayerFullScreen.layoutIfNeeded()
        view.layoutIfNeeded()
        audioPlayerFullScreen.layoutIfNeeded()
        audioPlayerFullScreen.configure()
        UIView.animate(withDuration: 0.6) {
            self.audioPlayerFullScreen.isHidden = false
        }
    }
}
