//
//  ToolsCollectionsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import qot_dal

final class ToolsCollectionsViewController: UIViewController {

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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .sand
        setCustomBackButton()
        UIApplication.shared.setStatusBar(colorMode: ColorMode.darkNot)
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        setCustomBackButton()
        UIApplication.shared.setStatusBar(colorMode: ColorMode.darkNot)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ToolsItemsViewController {
            ToolsItemsConfigurator.make(viewController: controller,
                                              selectedToolID: sender as? Int)
        }
    }
}

// MARK: - Private

private extension ToolsCollectionsViewController {

    func setupTableView() {
        tableView.registerDequeueable(ToolsCollectionsAudioTableViewCell.self)
        tableView.registerDequeueable(ToolsCollectionsVideoTableViewCell.self)
        tableView.registerDequeueable(ToolsCollectionsGroupTableViewCell.self)
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
            let title = headerTitle.replacingOccurrences(of: "Performance ", with: "") + " TOOLS"
            return ToolsTableHeaderView.instantiateFromNib(title: title, subtitle: "Introduction for section")
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIImageView(image: R.image.footer_light())
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
            cell.backgroundColor = .sand
            return cell
        } else if tool?.type == "video" {
            let cell: ToolsCollectionsVideoTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(title: tool?.title ?? "",
                           timeToWatch: tool?.durationString ?? "",
                           imageURL: tool?.imageURL)
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
                           remoteID: tool?.remoteID ?? 0)
            return cell
        } else {
            let cell: ToolsCollectionsAudioTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(categoryTitle: tool?.categoryTitle ?? "",
                           title: tool?.title ?? "",
                           timeToWatch: tool?.durationString ?? "",
                           mediaURL: tool?.mediaURL,
                           duration: tool?.duration ?? 0,
                           remoteID: tool?.remoteID ?? 0)
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
            trackUserEvent(.OPEN, value: tool?.remoteID ?? 0, valueType: .CONTENT_ITEM, action: .TAP)
            if tool?.type == "video" {
                guard
                    let videoTool = interactor?.videoTools[indexPath.row],
                    let videoURL = videoTool.mediaURL else { return }
                UIApplication.shared.setStatusBar(colorMode: ColorMode.dark)
                stream(videoURL: videoURL, contentItem: nil, pageName: PageName.learnContentItemFull) // TODO Set correct pageName
            } else if tool?.type == "pdf" {
                if let pdfURL = tool?.mediaURL {
                    didTapPDFLink(tool?.title ?? "", tool?.remoteID ?? 0, pdfURL)
                }
            }
        }
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
