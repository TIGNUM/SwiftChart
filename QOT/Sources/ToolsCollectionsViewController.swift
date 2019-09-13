//
//  ToolsCollectionsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol ToolsCollectionsViewControllerDelegate: class {
    func isPlaying() -> Bool
}

final class ToolsCollectionsViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    var interactor: ToolsCollectionsInteractorInterface?
    private enum CellType: Int, CaseIterable {
        case header = 0
        case sections
    }

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
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ToolsItemsViewController {
            ToolsItemsConfigurator.make(viewController: controller,
                                              selectedToolID: sender as? Int)
        }
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 0
        pageTrack.pageKey = pageKey
        pageTrack.associatedValueType = .CONTENT_CATEGORY
        pageTrack.associatedValueId = interactor?.selectedCategoryId()
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

// MARK: - Private

private extension ToolsCollectionsViewController {

    func setupTableView() {
        tableView.registerDequeueable(ToolsCollectionsAudioTableViewCell.self)
        tableView.registerDequeueable(ToolsCollectionsVideoTableViewCell.self)
        tableView.registerDequeueable(ToolsCollectionsGroupTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Actions

private extension ToolsCollectionsViewController {

    @IBAction func closeButton(_ sender: UIButton) {
        trackUserEvent(.CLOSE, action: .TAP)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - CoachViewControllerInterface

extension ToolsCollectionsViewController: ToolsCollectionsViewControllerInterface {

    func setupView() {
        setupTableView()
        setCustomBackButton()
    }

    func reload() {
        tableView.reloadData()
    }

    func audioIsPlayingForCell(index: IndexPath) {
        if let cell = tableView.cellForRow(at: index) as? ToolsCollectionsAudioTableViewCell {
            cell.delegate = self
        }
        tableView.reloadRows(at: [index], with: UITableViewRowAnimation.none)
    }
}

extension ToolsCollectionsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return interactor?.rowCount ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellType = CellType.allCases[section]
        switch cellType {
        case .header:
            let headerTitle = interactor?.headerTitle ?? ""
            guard headerTitle.count > 0 else { return nil }
            let title = headerTitle.replacingOccurrences(of: "Performance ", with: "") + " TOOLS"
            return ToolsTableHeaderView.instantiateFromNib(title: title, subtitle: "Introduction for section")
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tool = interactor?.tools[indexPath.item]
        if tool?.isCollection == true {
            let cell: ToolsCollectionsGroupTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(categoryTitle: tool?.categoryTitle ?? "",
                           title: tool?.title ?? "",
                           timeToWatch: tool?.durationString ?? "",
                           mediaURL: tool?.mediaURL,
                           duration: tool?.duration ?? 0,
                           remoteID: tool?.remoteID ?? 0,
                           numberOfItems: tool?.numberOfItems ?? 0,
                           type: tool?.type ?? "")
            cell.addTopLine(for: indexPath.row)
            return cell
        } else if tool?.type == "video" {
            let cell: ToolsCollectionsVideoTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(title: tool?.title ?? "",
                           timeToWatch: tool?.durationString ?? "",
                           imageURL: tool?.imageURL)
            cell.addTopLine(for: indexPath.row)
            cell.sizeToFit()
            cell.layoutIfNeeded()
            return cell
        } else if tool?.type == "audio" {
            let cell: ToolsCollectionsAudioTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(categoryTitle: tool?.categoryTitle ?? "",
                           title: tool?.title ?? "",
                           timeToWatch: tool?.durationString ?? "",
                           mediaURL: tool?.mediaURL,
                           duration: tool?.duration ?? 0,
                           remoteID: tool?.remoteID ?? 0,
                           delegate: self,
                           itemDelegate: nil)
            cell.delegate = self
            cell.addTopLine(for: indexPath.row)
            return cell
        } else {
            let cell: ToolsCollectionsAudioTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(categoryTitle: tool?.categoryTitle ?? "",
                           title: tool?.title ?? "",
                           timeToWatch: tool?.durationString ?? "",
                           mediaURL: tool?.mediaURL,
                           duration: tool?.duration ?? 0,
                           remoteID: tool?.remoteID ?? 0,
                           delegate: self,
                           itemDelegate: nil)
            cell.addTopLine(for: indexPath.row)
            cell.makePDFCell()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       let tool = interactor?.tools[indexPath.item]
        if tool?.isCollection == true {
            trackUserEvent(.OPEN, value: tool?.remoteID ?? 0, valueType: .CONTENT, action: .TAP)
            interactor?.presentToolsItems(selectedToolID: tool?.remoteID)
        } else {
            if let contentItemId = tool?.remoteID,
                let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(contentItemId)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            }
        }
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

extension ToolsCollectionsViewController: ToolsCollectionsViewControllerDelegate {

    func isPlaying() -> Bool {
        return interactor?.isPlaying ?? false
    }
}
