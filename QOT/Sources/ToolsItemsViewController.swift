//
//  ToolsItemsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

private enum ToolType: String {
    case video
    case audio
    case pdf
}

protocol IsPlayingDelegate: class {
    func isPlaying(remoteID: Int?) -> Bool
}

final class ToolsItemsViewController: BaseWithTableViewController, ScreenZLevel3 {

    private enum CellType: Int, CaseIterable {
        case header = 0
        case sections
    }

    // MARK: - Properties
    var interactor: ToolsItemsInteractorInterface!
    @IBOutlet weak var backButton: UIButton?
    private var lastAudioIndexPath: IndexPath?

    // MARK: - Init
    init(configure: Configurator<ToolsItemsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.qotTools.apply(view)
        ThemeView.qotTools.apply(tableView)
        interactor.viewDidLoad()
        _ = NotificationCenter.default.addObserver(forName: .didEndAudio,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didEndAudio(notification)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if self == navigationController?.viewControllers.first {
            backButton?.isHidden = true
        }
        super.viewWillAppear(animated)
        setStatusBar(colorMode: .darkNot)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 0
        pageTrack.pageKey = pageKey
        pageTrack.associatedValueType = .CONTENT_COLLECTION
        pageTrack.associatedValueId = interactor.selectedContentId()
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

// MARK: - Private
private extension ToolsItemsViewController {
    func setupTableView() {
        tableView.registerDequeueable(ToolsCollectionsAudioTableViewCell.self)
        tableView.registerDequeueable(ToolsCollectionsVideoTableViewCell.self)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 90
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
    }
}

// MARK: - Actions
private extension ToolsItemsViewController {
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func closeButton(_ sender: Any) {
        trackUserEvent(.CLOSE, action: .TAP)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - ToolsItemsViewControllerInterface
extension ToolsItemsViewController: ToolsItemsViewControllerInterface {
    func setupView() {
        ThemeTint.black.apply(backButton?.imageView ?? UIView.init())
        setupTableView()
    }

    func reload() {
        tableView.reloadData()
    }

    func audioPlayStateChangedForCellAt(indexPath: IndexPath) {
        var array: [IndexPath] = [indexPath]
        if let oldIndexPath = lastAudioIndexPath {
            array.append(oldIndexPath)
        }
        lastAudioIndexPath = indexPath
        tableView.reloadRows(at: array, with: .none)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ToolsItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.rowCount
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellType = CellType.allCases[section]
        switch cellType {
        case .header:
            return ToolsTableHeaderView.init(title: interactor.headerTitle,
                                             subtitle: interactor.headerSubtitle)
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tool = interactor.tools[indexPath.item]
        switch tool.type {
        case ToolType.video.rawValue:
            let cell: ToolsCollectionsVideoTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(title: tool.title,
                           timeToWatch: tool.durationString,
                           imageURL: tool.imageURL)
            cell.addTopLine(for: indexPath.row)
            cell.sizeToFit()
            cell.layoutIfNeeded()
            return cell
        case ToolType.audio.rawValue:
            let cell: ToolsCollectionsAudioTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(categoryTitle: tool.categoryTitle,
                           title: tool.title,
                           timeToWatch: tool.durationString,
                           mediaURL: tool.mediaURL,
                           duration: tool.duration,
                           remoteID: tool.remoteID,
                           delegate: self)
            cell.addTopLine(for: indexPath.row)
            return cell
        default:
            let cell: ToolsCollectionsAudioTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(categoryTitle: tool.categoryTitle,
                           title: tool.title,
                           timeToWatch: tool.durationString,
                           mediaURL: tool.mediaURL,
                           duration: tool.duration,
                           remoteID: tool.remoteID,
                           delegate: nil)
            cell.addTopLine(for: indexPath.row)
            cell.makePDFCell()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
        let tool = interactor.tools[indexPath.item]
        trackUserEvent(.OPEN, value: tool.remoteID, valueType: .CONTENT_ITEM, action: .TAP)
        switch ContentFormat(rawValue: tool.type) {
        case .audio:
            let media = MediaPlayerModel(title: tool.title,
                                         subtitle: "",
                                         url: tool.mediaURL,
                                         totalDuration: tool.duration,
                                         progress: 0,
                                         currentTime: 0,
                                         mediaRemoteId: tool.remoteID)
            NotificationCenter.default.post(name: .playPauseAudio, object: media)
            tableView.deselectRow(at: indexPath, animated: true)
            didDeselectRow(at: indexPath)
        case .video:
            if let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(tool.remoteID)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            }
        default:
            if let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(tool.remoteID)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRow(at: indexPath)
    }
}

// MARK: - Audio Player Related
extension ToolsItemsViewController {
    @objc func didEndAudio(_ notification: Notification) {
        tableView.reloadData()
    }

    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItemLight()]
    }
}

extension ToolsItemsViewController: IsPlayingDelegate {
    func isPlaying(remoteID: Int?) -> Bool {
        return interactor.isPlaying(remoteID: remoteID)
    }
}
