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
import Anchorage

protocol LearnContentItemViewControllerDelegate: class {

    func didTapShare(in viewController: LearnContentItemViewController)

    func didTapVideo(with video: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController)

    func didTapArticle(with article: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController)

    func didChangeTab(to nextIndex: Index, in viewController: TopTabBarController)
}

final class LearnContentItemViewController: UIViewController {

    // MARK: properties

    weak var delegate: LearnContentItemViewControllerDelegate?
    weak var serviceDelegate: LearnContentServiceDelegate?
    fileprivate let viewModel: LearnContentItemViewModel
    fileprivate let categoryTitle: String
    fileprivate let contentTitle: String

    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            style: .grouped,
            backgroundColor: .white,
            estimatedRowHeight: 10,
            delegate: self,
            dataSource: self,
            dequeables:
                ContentItemTextTableViewCell.self,
                ImageSubtitleTableViewCell.self,
                LearnContentItemBulletCell.self,
                ErrorCell.self
        )
    }()

    fileprivate lazy var headerView: LearnContentItemHeaderView = {
        let title = Style.postTitle(self.contentTitle, .darkIndigo).attributedString()
        let subTitle = Style.tag(self.categoryTitle, .black30).attributedString()
        let nib = R.nib.learnContentItemHeaderView()
        let headerView = (nib.instantiate(withOwner: self, options: nil).first as? LearnContentItemHeaderView)!
        headerView.setupView(title: title, subtitle: subTitle)
        headerView.backgroundColor = .white

        return headerView
    }()

    func isTableViewScrolledToTop() -> Bool {
        return self.tableView.contentOffset.y == -64
    }

    // MARK: Init
    
    init(viewModel: LearnContentItemViewModel, categoryTitle: String, contentTitle: String) {
        self.viewModel = viewModel
        self.categoryTitle = categoryTitle
        self.contentTitle = contentTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
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
        let item = contentItem(at: indexPath)
        let cotentItemValue = item.contentItemValue
        shouldMarkItemAsViewed(contentItem: item)

        switch cotentItemValue {
        case .listItem(let itemText):
            return contentItemBulletTableViewCell(
                tableView: tableView,
                indexPath: indexPath,
                bulletText: itemText
            )
        case .text(let itemText, let style):
            return contentItemTextTableViewCell(
                tableView: tableView,
                indexPath: indexPath,
                topText: item.contentItemValue.style(textStyle: style, text: itemText, textColor: .black),
                bottomText: nil
            )
        case .audio(let title, _, let placeholderURL, _, let duration, _),
             .video(let title, _, let placeholderURL, _, let duration):
            let mediaDescription = String(format: "%@ (%02i:%02i)", title, Int(duration) / 60 % 60, Int(duration) % 60)
            let attributedString = item.contentItemValue.style(textStyle: .paragraph, text: mediaDescription, textColor: .blackTwo)

            return mediaStreamCell(
                tableView: tableView,
                indexPath: indexPath,
                title: title,
                placeholderURL: placeholderURL,
                attributedString: attributedString
            )
        case .image(let title, _, let url):
            return imageTableViweCell(
                tableView: tableView,
                indexPath: indexPath,
                attributeString: item.contentItemValue.style(textStyle: .paragraph, text: title, textColor: .blackTwo).attributedString(),
                url: url
            )
        case .invalid:
            return invalidContentCell(tableView: tableView, indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contentItem = viewModel.learnContentItems(in: indexPath.section)
        let cotentItemValue = contentItem[indexPath.row].contentItemValue

        switch cotentItemValue {
        case .video: streamVideo()
        case .audio: streamVideo()
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(200)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }

        return headerView
    }
}

// MARK: - Private

private extension LearnContentItemViewController {

    func setupView() {
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
    }

    func contentItem(at indexPath: IndexPath) -> LearnContentItem {
        return viewModel.learnContentItems(in: indexPath.section)[indexPath.row]
    }

    func streamVideo() {
        let player = AVPlayer(url: URL(string: "http://avikam.com/wp-content/uploads/2016/09/SpeechRecognitionTutorial.mp4")!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }

    func contentItemBulletTableViewCell(
        tableView: UITableView,
        indexPath: IndexPath,
        bulletText: String) -> LearnContentItemBulletCell {
            let bulletCell: LearnContentItemBulletCell = tableView.dequeueCell(for: indexPath)
            bulletCell.setupView(bulletText: bulletText)

            return bulletCell
    }

    func contentItemTextTableViewCell(
        tableView: UITableView,
        indexPath: IndexPath,
        topText: NSAttributedString,
        bottomText: NSAttributedString?) -> ContentItemTextTableViewCell {
            let itemTextCell: ContentItemTextTableViewCell = tableView.dequeueCell(for: indexPath)
            itemTextCell.setup(topText: topText, bottomText: bottomText)

            return itemTextCell
    }

    func mediaStreamCell(
        tableView: UITableView,
        indexPath: IndexPath,
        title: String,
        placeholderURL: URL,
        attributedString: NSAttributedString) -> ImageSubtitleTableViewCell {
            let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            imageCell.setupData(
                placeHolder: placeholderURL,
                description: attributedString
            )
            imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14))

            return imageCell
    }

    func imageTableViweCell(
        tableView: UITableView,
        indexPath: IndexPath,
        attributeString: NSAttributedString,
        url: URL) -> ImageSubtitleTableViewCell {
            let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            imageCell.setupData(placeHolder: url, description: attributeString)
            imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14))

            return imageCell
    }

    func invalidContentCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ErrorCell = tableView.dequeueCell(for: indexPath)
        cell.configure(text: R.string.localized.commonInvalidContent())

        return cell
    }

    func shouldMarkItemAsViewed(contentItem: LearnContentItem?) {
        guard let contentItem = contentItem, contentItem.viewed == false else {
            return
        }

        serviceDelegate?.updatedViewedAt(with: contentItem.remoteID)
    }
}

// MARK: - TabBarViewDelegate

extension LearnContentItemViewController: TabBarViewDelegate {

    func didSelectItemAtIndex(index: Int, sender: TabBarView) {
        print("didSelectItemAtIndex", index, sender)

        tableView.reloadData()
    }
}

extension LearnContentItemViewController: LearnContentItemViewControllerDelegate {

    func didChangeTab(to nextIndex: Index, in viewController: TopTabBarController) {
        print("nextIndex", nextIndex)
    }

    func didTapShare(in viewController: LearnContentItemViewController) {
        log("did tap share")
    }

    func didTapVideo(with video: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        log("did tap video: \(video)")
    }

    func didTapArticle(with article: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        log("did tap article: \(article)")
    }
}
