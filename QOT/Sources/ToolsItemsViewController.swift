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

protocol ToolsItemsViewControllerDelegate: class {
    func isPlaying() -> Bool
}

final class ToolsItemsViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    var interactor: ToolsItemsInteractorInterface?
    @IBOutlet weak var backButton: UIButton!
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
        ThemeView.qotTools.apply(view)
        ThemeView.qotTools.apply(tableView)
        setCustomBackButton()
        interactor?.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didEndAudio(_:)), name: .didEndAudio, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        if self == self.navigationController?.viewControllers.first {
            backButton.isHidden = true
        }
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

    func audioPlayStateChangedForCellAt(indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ToolsCollectionsAudioTableViewCell {
            cell.itemDelegate = self
        }
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
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

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
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
                           remoteID: tool?.remoteID ?? 0,
                           delegate: nil,
                           itemDelegate: self)
            cell.addTopLine(for: indexPath.row)
            cell.itemDelegate = self
            return cell
        default:
            let cell: ToolsCollectionsAudioTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(categoryTitle: tool?.categoryTitle ?? "",
                           title: tool?.title ?? "",
                           timeToWatch: tool?.durationString ?? "",
                           mediaURL: tool?.mediaURL,
                           duration: tool?.duration ?? 0,
                           remoteID: tool?.remoteID ?? 0,
                           delegate: nil,
                           itemDelegate: self)
            cell.addTopLine(for: indexPath.row)
            cell.makePDFCell()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tool = interactor?.tools[indexPath.item]
        trackUserEvent(.OPEN, value: tool?.remoteID ?? 0, valueType: .CONTENT_ITEM, action: .TAP)
        if let contentItemId = tool?.remoteID,
            let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(contentItemId)) {
            UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
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

extension ToolsItemsViewController: ToolsItemsViewControllerDelegate {

    func isPlaying() -> Bool {
        return interactor?.isPlaying ?? false
    }
}
