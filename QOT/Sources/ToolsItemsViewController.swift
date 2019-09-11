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

final class ToolsItemsViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    var interactor: ToolsItemsInteractorInterface?

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private enum CellType: Int, CaseIterable {
        case header = 0
        case sections
    }

    init(configure: Configurator<ToolsItemsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .sand
        setCustomBackButton()
        interactor?.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didEndAudio(_:)), name: .didEndAudio, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCustomBackButton()
        setStatusBar(colorMode: ColorMode.darkNot)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 0
        pageTrack.pageKey = pageKey
        pageTrack.associatedValueType = .CONTENT_COLLECTION
        pageTrack.associatedValueId = interactor?.selectedContentId()
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

// MARK: - Private

private extension ToolsItemsViewController {

    func setupTableView() {
        tableView.registerDequeueable(ToolsCollectionsAudioTableViewCell.self)
        tableView.registerDequeueable(ToolsCollectionsVideoTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
    }
}

// MARK: - Actions

private extension ToolsItemsViewController {

    @IBAction func closeButton(_ sender: Any) {
        trackUserEvent(.CLOSE, action: .TAP)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - CoachViewControllerInterface

extension ToolsItemsViewController: ToolsItemsViewControllerInterface {

    func setupView() {
        setupTableView()
        setCustomBackButton()
    }

    func reload() {
        tableView.reloadData()
    }
}

extension ToolsItemsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.rowCount ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellType = CellType.allCases[section]
        switch cellType {
        case .header:
            return ToolsTableHeaderView.instantiateFromNib(title: interactor?.headerTitle ?? "",
                                                           subtitle: interactor?.headerSubtitle ?? "")
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tool = interactor?.tools[indexPath.item]
        switch tool?.type {
        case ToolType.video.rawValue:
            let cell: ToolsCollectionsVideoTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(title: tool?.title ?? "video title",
                           timeToWatch: tool?.durationString ?? "",
                           imageURL: tool?.imageURL)
            cell.addTopLine(for: indexPath.row)
            cell.sizeToFit()
            cell.layoutIfNeeded()
            return cell
        case ToolType.audio.rawValue:
            let cell: ToolsCollectionsAudioTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(categoryTitle: tool?.categoryTitle ?? "",
                           title: tool?.title ?? "",
                           timeToWatch: tool?.durationString ?? "",
                           mediaURL: tool?.mediaURL,
                           duration: tool?.duration ?? 0,
                           remoteID: tool?.remoteID ?? 0)
            cell.addTopLine(for: indexPath.row)
            return cell
        default:
            let cell: ToolsCollectionsAudioTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(categoryTitle: tool?.categoryTitle ?? "",
                           title: tool?.title ?? "",
                           timeToWatch: tool?.durationString ?? "",
                           mediaURL: tool?.mediaURL,
                           duration: tool?.duration ?? 0,
                           remoteID: tool?.remoteID ?? 0)
            cell.addTopLine(for: indexPath.row)
            cell.makePDFCell()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tool = interactor?.tools[indexPath.item]
        trackUserEvent(.OPEN, value: tool?.remoteID ?? 0, valueType: .CONTENT_ITEM, action: .TAP)
        switch tool?.type {
        case ToolType.video.rawValue:
            guard
                let videoTool = interactor?.tools[indexPath.row],
                let videoURL = videoTool.mediaURL else { return }
            stream(videoURL: videoURL, contentItem: nil) // TODO Set correct pageName
        case ToolType.audio.rawValue:
            let media = MediaPlayerModel(title: tool?.title ?? "",
                                         subtitle: tool?.categoryTitle ?? "",
                                         url: tool?.mediaURL,
                                         totalDuration: 0, progress: 0, currentTime: 0, mediaRemoteId: tool?.remoteID ?? 0)
            NotificationCenter.default.post(name: .playPauseAudio, object: media)
        default:
            if let pdfURL = tool?.mediaURL {
                self.showPDFReader(withURL: pdfURL, title: tool?.title ?? "", itemID: tool?.remoteID ?? 0)
            }
        }
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
