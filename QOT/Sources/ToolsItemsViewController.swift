//
//  ToolsItemsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import qot_dal

protocol AudioToolPlayerDelegate: class {
    func didTabPlayPause(categoryTitle: String, title: String, audioURL: URL?, remoteID: Int)
    func didTabClose(for view: AudioPlayer.View)
    func didFinishAudio()
    func openFullScreen()
}

private enum ToolType: String {
    case video
    case audio
    case pdf
}

final class ToolsItemsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    var interactor: ToolsItemsInteractorInterface?
    private var audioPlayerBar = AudioPlayerBar()
    private var audioPlayerFullScreen = AudioPlayerFullScreen()
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
    }

    override func viewWillAppear(_ animated: Bool) {
        setCustomBackButton()
        UIApplication.shared.setStatusBar(colorMode: ColorMode.darkNot)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Private

private extension ToolsItemsViewController {

    func setupTableView() {
        tableView.registerDequeueable(ToolsCollectionsAudioTableViewCell.self)
        tableView.registerDequeueable(ToolsCollectionsVideoTableViewCell.self)
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
        setupAudioPlayerView()
    }
}

private extension ToolsItemsViewController {

    func setupAudioPlayerView() {
        audioPlayerBar = AudioPlayerBar.instantiateFromNib()
        view.addSubview(audioPlayerBar)
        audioPlayerBar.contentView.backgroundColor = .carbon
        audioPlayerBar.trailingAnchor == view.trailingAnchor
        audioPlayerBar.leadingAnchor == view.leadingAnchor
        audioPlayerBar.bottomAnchor == view.bottomAnchor - 24
        audioPlayerBar.heightAnchor == 40
        audioPlayerBar.layoutIfNeeded()
        audioPlayerBar.isHidden = true
        audioPlayerBar.toolViewDelegate = self
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

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIImageView(image: R.image.footer_light())
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
            cell.sizeToFit()
            cell.layoutIfNeeded()
            return cell
        case ToolType.audio.rawValue:
            let cell: ToolsCollectionsAudioTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.toolViewDelegate = self
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
            cell.configure(categoryTitle: tool?.categoryTitle ?? "",
                           title: tool?.title ?? "",
                           timeToWatch: tool?.durationString ?? "",
                           mediaURL: tool?.mediaURL,
                           duration: tool?.duration ?? 0,
                           remoteID: tool?.remoteID ?? 0)
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
            stream(videoURL: videoURL, contentItem: nil, pageName: PageName.learnContentItemFull) // TODO Set correct pageName
            UIApplication.shared.setStatusBar(colorMode: ColorMode.dark)
        case ToolType.audio.rawValue:
            didTabPlayPause(categoryTitle: tool?.categoryTitle ?? "",
                            title: tool?.title ?? "",
                            audioURL: tool?.mediaURL,
                            remoteID: tool?.remoteID ?? 0)
        default:
            if let pdfURL = tool?.mediaURL {
                didTapPDFLink(tool?.title ?? "", tool?.remoteID ?? 0, pdfURL)
            }
        }
    }
}

// MARK: - Functions

extension ToolsItemsViewController {

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

// MARK: - AudioPlayerViewDelegate

extension ToolsItemsViewController: AudioToolPlayerDelegate {

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
                                 remoteID: remoteID,
                                 titleColor: .accent)
    }

    func didFinishAudio() {
        tableView.reloadData()
    }

    func openFullScreen() {
        audioPlayerFullScreen = AudioPlayerFullScreen.instantiateFromNib()
        audioPlayerFullScreen.toolViewDelegate = self
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
