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
import ReactiveKit
import Bond

protocol LearnContentItemViewControllerDelegate: class {

    func didTapShare(in viewController: LearnContentItemViewController)

    func didTapVideo(with video: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController)

    func didTapArticle(with article: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController)

    func didChangeTab(to nextIndex: Index, in viewController: TopTabBarController)

    func didTapFinish(from view: UIView)
}

final class LearnContentItemViewController: UIViewController {

    // MARK: properties

    weak var delegate: LearnContentItemViewControllerDelegate?
    weak var serviceDelegate: LearnContentServiceDelegate?
    fileprivate let disposeBag = DisposeBag()
    fileprivate let viewModel: LearnContentItemViewModel
    fileprivate let categoryTitle: String
    fileprivate let contentTitle: String
    fileprivate let tabType: TabType
    fileprivate var soundPattern = Property([Float(0)])

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
                LearnStrategyAudioPlayerView.self,
                LearnStrategyPlaylistAudioCell.self,
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
    
    init(viewModel: LearnContentItemViewModel, categoryTitle: String, contentTitle: String, tabType: TabType) {
        self.viewModel = viewModel
        self.categoryTitle = categoryTitle
        self.contentTitle = contentTitle
        self.tabType = tabType
        
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
        return viewModel.sectionCount(tabType)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(in: section, tabType: tabType)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tabType {
        case .audio: return indexPath.section == 0 ? CGFloat(100) : UITableViewAutomaticDimension
        case .bullets,
             .full: return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tabType: ", tabType)
        print("section: ", indexPath.section)
        print("row", indexPath.row)
        print("..............")
        switch tabType {
        case .audio: return audioCell(tableView, indexPath)
        case .bullets,
             .full: return indexPath.section == 0 ? contentItemCell(tableView, indexPath) : relatedContentCell(tableView, indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cotentItemValue = viewModel.learnContentItem(at: indexPath, tabType: tabType).contentItemValue

        switch tabType {
        case .audio:
            switch cotentItemValue {
            case .audio(_, _, _, let audioURL, let duration, _):
                viewModel.playItem(at: indexPath, audioURL: audioURL, duration: duration)
            default: return
            }
        case .bullets,
             .full:
            switch cotentItemValue {
             case .video: streamVideo()
             case .audio: streamVideo()
             default: return
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tabType {
        case .audio: return section == 0 ? CGFloat(200) : CGFloat(0)
        case .bullets,
             .full: return section == 0 ? CGFloat(200) : CGFloat(44)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tabType {
        case .audio: return section == 0 ? headerView : nil
        case .bullets,
             .full: return section == 0 ? headerView : contentItemTextTableViewCell(
                tableView: tableView,
                indexPath: IndexPath(row: 0, section: 1),
                topText: NSMutableAttributedString(
                    string: R.string.localized.prepareContentReadMore().capitalized,
                    font: Font.H5SecondaryHeadline,
                    textColor: .black),
                bottomText: nil
            )
        }
    }
}

// MARK: - Audio/Private

private extension LearnContentItemViewController {

    func audioCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let audioItem = viewModel.contentItems(at: .audio)[indexPath.row]
        print("audioItem: ", audioItem)
        switch audioItem.contentItemValue {
        case .audio(let title, _, _, _, let duration, let waveformData):
            switch indexPath.section {
            case 0:
                let cell: LearnStrategyAudioPlayerView = tableView.dequeueCell(for: indexPath)
                viewModel.trackDuration = Property(duration)
                soundPattern = Property(waveformData)
                observeViewModel(audioView: cell)

                return cell
            case 1:
                let cell: LearnStrategyPlaylistAudioCell = tableView.dequeueCell(for: indexPath)
                cell.setUp(title: title, playing: viewModel.isPlaying(indexPath: indexPath))

                return cell
            case 3:
                return indexPath.section > 0 ? contentItemCell(tableView, indexPath) : relatedContentCell(tableView, indexPath)
            default:
                return indexPath.section > 0 ? contentItemCell(tableView, indexPath) : relatedContentCell(tableView, indexPath)
            }
        default:
            return indexPath.section > 0 ? contentItemCell(tableView, indexPath) : relatedContentCell(tableView, indexPath)
        }
    }

    private func observeViewModel(audioView: LearnStrategyAudioPlayerView) {
        viewModel.currentPosition.map { [unowned self] (interval) -> String in
            return self.stringFromTimeInterval(interval: interval)
        }.bind(to: audioView.currentPositionLabel)

        viewModel.trackDuration.map { [unowned self] (interval) -> String in
            return self.stringFromTimeInterval(interval: interval)
        }.bind(to: audioView.trackDurationLabel)

        viewModel.currentPosition.observeNext { [unowned self] (interval) in
            let value = self.progress(currentPosition: interval, trackDuration: self.viewModel.trackDuration.value)
            audioView.audioSlider.value = Float(value)
            audioView.audioWaveformView.setProgress(value: Float(value))
        }.dispose(in: disposeBag)

        soundPattern.observeNext { (data) in
            audioView.audioWaveformView.data = data
        }.dispose(in: disposeBag)

        viewModel.updates.observeNext { [unowned self] (_) in
            self.tableView.reloadData()
        }.dispose(in: disposeBag)
    }

    private func progress(currentPosition: TimeInterval, trackDuration: TimeInterval) -> CGFloat {
        return trackDuration > 0 ? CGFloat(currentPosition / trackDuration) : 0
    }

    private func stringFromTimeInterval(interval: TimeInterval?) -> String {
        guard let interval = interval else {
            return "00:00"
        }

        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        let time = formatter.string(from: interval)

        return time ?? "00:00"
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

    func cell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.learnContentItem(at: indexPath, tabType: tabType)
        shouldMarkItemAsViewed(contentItem: item)

        switch item.contentItemValue {
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
            let attributedString = NSMutableAttributedString(
                string: mediaDescription,
                font: Font.DPText,
                lineSpacing: 14,
                textColor: .blackTwo
            )

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

    func relatedContentCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let relatedContent = viewModel.relatedContent(at: indexPath)
        let topText = NSMutableAttributedString(
            string: relatedContent.title,
            letterSpacing: CGFloat(-0.8),
            font: Font.H4Headline,
            textColor: .black)
        let bottomText = NSMutableAttributedString(
            string: String(format: "%d MIN TO READ", relatedContent.minutesRequired),
            letterSpacing: CGFloat(2),
            font: Font.H7Tag,
            textColor: .black30)

        return contentItemTextTableViewCell(
            tableView: tableView,
            indexPath: indexPath,
            topText: topText,
            bottomText: bottomText
        )
    }

    func contentItemCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.learnContentItem(at: indexPath, tabType: tabType)
        shouldMarkItemAsViewed(contentItem: item)

        switch item.contentItemValue {
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
            return mediaStreamCell(
                tableView: tableView,
                indexPath: indexPath,
                title: title,
                placeholderURL: placeholderURL,
                attributedString: item.contentItemValue.style(textStyle: .paragraph, text: mediaDescription, textColor: .blackTwo).attributedString()
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
            imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))

            return imageCell
    }

    func imageTableViweCell(
        tableView: UITableView,
        indexPath: IndexPath,
        attributeString: NSAttributedString,
        url: URL) -> ImageSubtitleTableViewCell {
            let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            imageCell.setupData(placeHolder: url, description: attributeString)
            imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))

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

// MARK: - AudioPlayerViewSliderDelegate

extension LearnContentItemViewController: AudioPlayerViewSliderDelegate {

    func value(at layout: Float, in view: LearnStrategyAudioPlayerView) {
        viewModel.forward(value: layout)
    }
}

// MARK: - LearnContentItemViewControllerDelegate

extension LearnContentItemViewController: LearnContentItemViewControllerDelegate {

    func didTapFinish(from view: UIView) {
        print("didTapFinish")
    }

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
