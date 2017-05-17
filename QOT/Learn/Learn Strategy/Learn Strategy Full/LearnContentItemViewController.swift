//
//  LearnContentItemViewController.swift
//  QOT
//
//  Created by karmic on 29/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import RealmSwift

protocol LearnContentItemViewControllerDelegate: class {
    func didTapClose(in viewController: LearnContentItemViewController)
    func didTapShare(in viewController: LearnContentItemViewController)
    func didTapVideo(with video: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController)
    func didTapArticle(with article: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController)
}

final class LearnContentItemViewController: UIViewController {

    // MARK: properties

    weak var delegate: LearnContentItemViewControllerDelegate?
    weak var serviceDelegate: LearnContentServiceDelegate?
    fileprivate let viewModel: LearnContentItemViewModel
    fileprivate var tableView = UITableView()
    fileprivate let scrollToClosePadding: CGFloat = 100

    // MARK: Init
    
    init(viewModel: LearnContentItemViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    
    // MARK: Private methods
    
    private func setupTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
        tableView.registerDequeueable(ContentItemTextTableViewCell.self)
        tableView.registerDequeueable(ImageSubtitleTableViewCell.self)
        view.addSubview(tableView)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension LearnContentItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contentItem = viewModel.learnContentItems(in: indexPath.section)[indexPath.row]
        let cotentItemValue = contentItem.contentItemValue
        shouldMarkItemAsViewed(contentItem: contentItem as? ContentItem)

        switch cotentItemValue {
        case .bullet(let bulletItem, let itemText):
            return contentItemTextTableViewCell(
                tableView: tableView,
                indexPath: indexPath,
                itemText: itemText
            )
        case .text(let itemText):
            return contentItemTextTableViewCell(
                tableView: tableView,
                indexPath: indexPath,
                itemText: itemText
            )
        case .audio(let title, _, let placeholderURL, _, let duration, _),
             .video(let title, _, let placeholderURL, _, let duration):
            return mediaStreamCell(
                tableView: tableView,
                indexPath: indexPath,
                title: title,
                placeholderURL: placeholderURL,
                duration: duration
            )
        case .image(let title, _, let url):
            return imageTableViweCell(
                tableView: tableView,
                indexPath: indexPath,
                title: title,
                url: url
            )
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contentItem = viewModel.learnContentItems(in: indexPath.section)
        let cotentItemValue = contentItem[indexPath.row].contentItemValue

        switch cotentItemValue {
        case .video(_, _, _, _, _): streamVideo()
        case .audio(_, _, _, _, _, _): streamVideo()
        case .image(_, _, _),
             .bullet(_),
             .text(_): return
        }
    }

    private func streamVideo() {
        let player = AVPlayer(url: URL(string: "http://avikam.com/wp-content/uploads/2016/09/SpeechRecognitionTutorial.mp4")!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }

    private func contentItemTextTableViewCell(
        tableView: UITableView,
        indexPath: IndexPath,
        itemText: String) -> ContentItemTextTableViewCell {
            let itemTextCell: ContentItemTextTableViewCell = tableView.dequeueCell(for: indexPath)
            itemTextCell.setup(topText: AttributedString.Learn.articleTitle(string: itemText), bottomText: nil)
            return itemTextCell
    }

    private func mediaStreamCell(
        tableView: UITableView,
        indexPath: IndexPath,
        title: String,
        placeholderURL: URL,
        duration: TimeInterval) -> ImageSubtitleTableViewCell {
            let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            let mediaDescription = String(format: "%@ (%02i:%02i)", title, Int(duration) / 60 % 60, Int(duration) % 60)
            imageCell.setupData(
                placeHolder: placeholderURL,
                description: AttributedString.Learn.mediaDescription(string: mediaDescription)
            )
            imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14))
            return imageCell
    }

    private func imageTableViweCell(
        tableView: UITableView,
        indexPath: IndexPath,
        title: String,
        url: URL) -> ImageSubtitleTableViewCell {
            let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            imageCell.setupData(placeHolder: url, description: AttributedString.Learn.mediaDescription(string: title))
            imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14))
            return imageCell
    }

    private func shouldMarkItemAsViewed(contentItem: ContentItem?) {
        guard let contentItem = contentItem, contentItem.viewed == false else {
            return
        }

        serviceDelegate?.updatedViewedAt(with: contentItem.remoteID, at: Date())
    }
}
