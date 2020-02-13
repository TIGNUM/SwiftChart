//
//  ToolsCollectionsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ToolsCollectionsViewController: BaseWithTableViewController, ScreenZLevel3 {

    // MARK: - Properties

    @IBOutlet private weak var backArrow: UIButton!
    private let mindsetShifterChatBotId = 102453
    private let recoveryChatBotId = 102451
    var interactor: ToolsCollectionsInteractorInterface!
    private var lastAudioIndexPath: IndexPath?
    private enum CellType: Int, CaseIterable {
        case header = 0
        case sections
    }
    @IBOutlet weak var backButton: UIButton!

    init(configure: Configurator<ToolsCollectionsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.qotTools.apply(view)
        ThemeView.qotTools.apply(tableView)
        setStatusBar(colorMode: ColorMode.darkNot)
        interactor.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self == self.navigationController?.viewControllers.first {
            backArrow.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toolID = sender as? Int,
            let controller = segue.destination as? ToolsItemsViewController {
            ToolsItemsConfigurator.make(viewController: controller,
                                              selectedToolID: toolID)
        }
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 0
        pageTrack.pageKey = pageKey
        pageTrack.associatedValueType = .CONTENT_CATEGORY
        pageTrack.associatedValueId = interactor.selectedCategoryId()
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

// MARK: - Private

private extension ToolsCollectionsViewController {

    func setupTableView() {
        tableView.registerDequeueable(ToolsCollectionsAudioTableViewCell.self)
        tableView.registerDequeueable(ToolsCollectionsVideoTableViewCell.self)
        tableView.registerDequeueable(ToolsCollectionsGroupTableViewCell.self)
        tableView.registerDequeueable(ToolsTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 60
    }
}

// MARK: - Actions

private extension ToolsCollectionsViewController {

    @IBAction func closeButton(_ sender: UIButton) {
        trackUserEvent(.CLOSE, action: .TAP)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - ToolsViewControllerInterface

extension ToolsCollectionsViewController: ToolsCollectionsViewControllerInterface {

    func setupView() {
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
        tableView.reloadRows(at: array, with: UITableViewRowAnimation.none)
    }
}

extension ToolsCollectionsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return interactor.rowCount
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellType = CellType.allCases[section]
        switch cellType {
        case .header:
            let headerTitle = interactor.headerTitle
            if headerTitle.count > 0 {
                let title = headerTitle.replacingOccurrences(of: "Performance ", with: "") + " TOOLS"
                return ToolsTableHeaderView.init(title: title.uppercased(), subtitle: nil)
            }
        default:
            break
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tool = interactor.tools[indexPath.item]
        if tool.isCollection == true {
            let cell: ToolsCollectionsGroupTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(categoryTitle: tool.categoryTitle,
                           title: tool.title,
                           timeToWatch: tool.durationString,
                           mediaURL: tool.mediaURL,
                           duration: tool.duration,
                           remoteID: tool.remoteID,
                           numberOfItems: tool.numberOfItems,
                           type: tool.type)
            cell.addTopLine(for: indexPath.row)
            return cell
        } else if tool.type == "video" {
            let cell: ToolsCollectionsVideoTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(title: tool.title,
                           timeToWatch: tool.durationString,
                           imageURL: tool.imageURL)
            cell.addTopLine(for: indexPath.row)
            cell.sizeToFit()
            cell.layoutIfNeeded()
            return cell
        } else if tool.type == "audio" {
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
        } else if tool.type == "pdf" {
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
            cell.accessoryView = UIImageView(image: R.image.ic_disclosure_accent())
            return cell
        } else {
            let cell: ToolsTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(title: tool.title,
                           subtitle: AppTextService.get(.coach_tools_labels_label_interactive))
            cell.addTopLine(for: indexPath.row)
            cell.accessoryView = UIImageView(image: R.image.ic_disclosure_accent())
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
        let tool = interactor.tools[indexPath.item]
        if tool.isCollection == true {
            trackUserEvent(.OPEN, value: tool.remoteID, valueType: .CONTENT, action: .TAP)
            interactor.presentToolsItems(selectedToolID: tool.remoteID)
        } else if tool.contentCollectionId == recoveryChatBotId {
            interactor.presentDTRecovery()
        } else if tool.contentCollectionId == mindsetShifterChatBotId {
            interactor.presentDTMindetShifter()
        } else {
            if let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(tool.remoteID)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRow(at: indexPath)
    }
}

// MARK: - Bottom Navigation
extension ToolsCollectionsViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItemLight()]
    }
}

// MARK: - Private

private extension ToolsCollectionsViewController {

    func didTapPDFLink(_ title: String?, _ itemID: Int, _ url: URL) {
        let storyboard = UIStoryboard(name: "PDFReaderViewController", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return
        }
        guard let readerViewController = navigationController.viewControllers.first as? PDFReaderViewController else {
            return
        }
        let pdfReaderConfigurator = PDFReaderConfigurator.make(contentItemID: itemID, title: title ?? "", url: url)
        pdfReaderConfigurator(readerViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

extension ToolsCollectionsViewController: IsPlayingDelegate {

    func isPlaying(remoteID: Int?) -> Bool {
        return interactor.isPlaying(remoteID: remoteID)
    }
}
