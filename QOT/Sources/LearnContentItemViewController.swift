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

    func didTapVideo(with video: ContentItem, from view: UIView, in viewController: LearnContentItemViewController)

    func didTapArticle(with article: ContentItem, from view: UIView, in viewController: LearnContentItemViewController)

    func didChangeTab(to nextIndex: Index, in viewController: TopTabBarController)

    func didTapFinish(from view: UIView)

    func didSelectReadMoreContentCollection(with collectionID: Int, in viewController: LearnContentItemViewController)

    func didViewContentItem(id: Int, in viewController: LearnContentItemViewController)
}

final class LearnContentItemViewController: UIViewController {

    // MARK: properties

    weak var delegate: LearnContentItemViewControllerDelegate?
    fileprivate let disposeBag = DisposeBag()
    fileprivate var viewModel: LearnContentItemViewModel
    fileprivate let categoryTitle: String
    fileprivate var contentTitle: String
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

    fileprivate func headerView(contentTitle: String, categoryTitle: String) -> LearnContentItemHeaderView {
        let title = Style.postTitle(contentTitle.uppercased(), .darkIndigo).attributedString()
        let subTitle = Style.tag(categoryTitle.uppercased(), .black30).attributedString()
        let nib = R.nib.learnContentItemHeaderView()
        let headerView = (nib.instantiate(withOwner: self, options: nil).first as? LearnContentItemHeaderView)!
        headerView.setupView(title: title, subtitle: subTitle)
        headerView.backgroundColor = .white

        return headerView
    }

    func isTableViewScrolledToTop() -> Bool {
        return self.tableView.contentOffset.y == -64
    }

    // MARK: Init
    
    init(viewModel: LearnContentItemViewModel, categoryTitle: String, contentTitle: String, tabType: TabType) {
        self.viewModel = viewModel
        self.categoryTitle = categoryTitle.capitalized
        self.contentTitle = contentTitle.capitalized
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

    func reloadData(viewModel: LearnContentItemViewModel, contentTitle: String) {
        self.viewModel = viewModel
        self.contentTitle = contentTitle
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension LearnContentItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(in: section, tabType: tabType)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow(at: indexPath.section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.learnContentItem(at: indexPath, tabType: tabType)
        shouldMarkItemAsViewed(contentItem: item)

        if viewModel.containsAudioItem() == true && indexPath.section == 0 {
            switch viewModel.firstAudioItem() {
            case .audio(_, _, _, _, let duration, let waveformData):
                let cell: LearnStrategyAudioPlayerView = tableView.dequeueCell(for: indexPath)
                viewModel.trackDuration = Property(duration)
                soundPattern = Property(waveformData)
                observeViewModel(audioView: cell)
                return cell
            default: fatalError("That should not happen!")
            }
        } else if
            viewModel.sectionCount() == 3 && indexPath.section == 2 ||
            viewModel.sectionCount() == 2 && viewModel.containsAudioItem() == false && indexPath.section == 1 {
            return relatedContentCell(tableView, indexPath)
        } else {
            switch item.contentItemValue {
            case .listItem(let itemText):
                return contentItemBulletTableViewCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    bulletText: itemText
                )
            case .text(let itemText, let style):
                var attributedTopText = item.contentItemValue.style(textStyle: style, text: itemText, textColor: .black)
                if style == .paragraph {
                    attributedTopText = Style.article(itemText, .black).attributedString(lineHeight: 2)
                }
                
                return contentItemTextTableViewCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    topText: attributedTopText,
                    bottomText: nil
                )
            case .audio(let title, _, _, _, let duration, let waveformData):
                return contentItemAudioCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    title: title,
                    duration: duration,
                    waveFormData: waveformData
                )
            case .video(let title, _, let placeholderURL, _, let duration):
                let mediaDescription = String(format: "%@ (%02i:%02i)", title, Int(duration) / 60 % 60, Int(duration) % 60)
                return mediaStreamCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    title: title,
                    placeholderURL: placeholderURL,
                    attributedString: item.contentItemValue.style(textStyle: .paragraph, text: mediaDescription, textColor: .black40).attributedString(),
                    canStream: true
                )
            case .image(let title, _, let url):
                return imageTableViweCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    attributeString: item.contentItemValue.style(textStyle: .paragraph, text: title, textColor: .blackTwo).attributedString(),
                    url: url
                )
            default:
                return invalidContentCell(tableView: tableView, indexPath: indexPath)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item =  viewModel.learnContentItem(at: indexPath, tabType: tabType)
        switch item.contentItemValue {
        case .audio(_, _, _, let audioURL, let duration, _):
            viewModel.playItem(at: indexPath, audioURL: audioURL, duration: duration)
        case .video(_, _, _, let videoURL, _):
            streamVideo(videoURL: videoURL)
        default:
            if
                viewModel.sectionCount() == 3 && indexPath.section == 2 ||
                viewModel.sectionCount() == 2 && viewModel.containsAudioItem() == false && indexPath.section == 1 {
                    let selectedItem = viewModel.relatedContent(at: indexPath)
                    print("viewModel.relatedContent(at: indexPath)", selectedItem)
                    delegate?.didSelectReadMoreContentCollection(with: selectedItem.remoteID, in: self)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat(200) : CGFloat(44)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? headerView(contentTitle: contentTitle.uppercased(), categoryTitle: categoryTitle.uppercased()) : contentItemTextTableViewCell(
            tableView: tableView,
            indexPath: IndexPath(row: 0, section: 1),
            topText: NSMutableAttributedString(
                string: R.string.localized.prepareContentReadMore().uppercased(),
                font: Font.H5SecondaryHeadline,
                textColor: .black),
            bottomText: nil
        )
    }
}

// MARK: - Audio/Private

private extension LearnContentItemViewController {

    func observeViewModel(audioView: LearnStrategyAudioPlayerView) {
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

    func shouldMarkItemAsViewed(contentItem: ContentItem?) {
        guard let contentItem = contentItem, contentItem.viewed == false else {
            return
        }

        delegate?.didViewContentItem(id: contentItem.remoteID, in: self)
    }

    func relatedContentCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let relatedContent = viewModel.relatedContent(at: indexPath)
        let topText = NSMutableAttributedString(
            string: relatedContent.title,
            letterSpacing: CGFloat(-0.8),
            font: Font.H4Headline,
            textColor: .black
        )
        let bottomText = NSMutableAttributedString(
            string: String(format: "%d MIN TO READ", relatedContent.minutesRequired), //TODO Localise
            letterSpacing: CGFloat(2),
            font: Font.H7Tag,
            textColor: .black30
        )
        let cell = contentItemTextTableViewCell(
            tableView: tableView,
            indexPath: indexPath,
            topText: topText,
            bottomText: bottomText
        )
        cell.selectionStyle = .gray

        return cell
    }

    func streamVideo(videoURL: URL) {
        let player = AVPlayer(url: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }

    func contentItemAudioCell(
        tableView: UITableView,
        indexPath: IndexPath,
        title: String,
        duration: TimeInterval,
        waveFormData: [Float]) -> LearnStrategyPlaylistAudioCell {
            let cell: LearnStrategyPlaylistAudioCell = tableView.dequeueCell(for: indexPath)
            cell.setUp(title: title, playing: viewModel.isPlaying(indexPath: indexPath))

            return cell
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
        attributedString: NSAttributedString,
        canStream: Bool) -> ImageSubtitleTableViewCell {
            let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            imageCell.setupData(
                placeHolder: placeholderURL,
                description: attributedString,
                canStream: canStream
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
            imageCell.setupData(placeHolder: url, description: attributeString, canStream: false)
            imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))

            return imageCell
    }

    func invalidContentCell(tableView: UITableView, indexPath: IndexPath) -> ErrorCell {
        let cell: ErrorCell = tableView.dequeueCell(for: indexPath)
        cell.configure(text: R.string.localized.commonInvalidContent())

        return cell
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
