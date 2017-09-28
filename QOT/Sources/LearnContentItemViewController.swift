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

    func didTapFinish(from view: UIView)

    func didTapPDF(withURL url: URL, in viewController: LearnContentItemViewController)

    func didSelectReadMoreContentCollection(with collectionID: Int, in viewController: LearnContentItemViewController)
}

final class LearnContentItemViewController: UIViewController {

    // MARK: properties

    weak var delegate: LearnContentItemViewControllerDelegate?
    var viewModel: LearnContentItemViewModel
    let tabType: TabType
    fileprivate var audioPlayerTopView: LearnStrategyAudioPlayerView?
    fileprivate let disposeBag = DisposeBag()
    fileprivate var soundPattern = Property([Float(0)])

    fileprivate lazy var itemTableView: UITableView = {
        return UITableView(style: .grouped,
                           backgroundColor: .white,
                           estimatedRowHeight: 10,
                           delegate: self,
                           dataSource: self,
                           dequeables: ContentItemTextTableViewCell.self,
                                       ImageSubtitleTableViewCell.self,
                                       LearnContentItemBulletCell.self,
                                       LearnStrategyAudioPlayerView.self,
                                       LearnStrategyPlaylistAudioCell.self,
                                       LearnReadMoreCell.self,
                                       LearnPDFCell.self,
                                       ErrorCell.self)
    }()

    // MARK: Init
    
    init(viewModel: LearnContentItemViewModel, tabType: TabType) {
        self.viewModel = viewModel
        self.tabType = tabType
        
        super.init(nibName: nil, bundle: nil)

        if tabType == .audio {
            observeViewModelPlayerUpdates()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        if let parent = parent as? PageScroll {
            parent.pageDidLoad(self, scrollView: itemTableView)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.statusBarStyle = .default
        itemTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.stopPlayback()
    }

    func reloadData(viewModel: LearnContentItemViewModel) {
        self.viewModel = viewModel
        //TODO:this
        //self.contentTitle = viewModel.contentTitle
        itemTableView.reloadData()
        let sections = itemTableView.numberOfSections
        let rowsInSection = itemTableView.numberOfRows(inSection: 0)

        if 0 < sections && 0 < rowsInSection {
            itemTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension LearnContentItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount(tabType: tabType)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(in: section, tabType: tabType)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow(at: indexPath.section, tabType: tabType)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: ContentItem!

        if viewModel.isPDFItem(at: indexPath, tabType: tabType) {
            item = viewModel.learnPDFContentItem(at: indexPath, tabType: tabType)
        } else if viewModel.isReadMoreItem(at: indexPath, tabType: tabType) {
            return readMoreTableViewCell(tableView: tableView, indexPath: indexPath)
        } else {
            item = viewModel.learnContentItem(at: indexPath, tabType: tabType)
        }

        shouldMarkItemAsViewed(contentItem: item)

        if viewModel.containsAudioItem(tabType: tabType) == true && indexPath.section == 0 {            
            switch viewModel.firstAudioItem() {
            case .audio(_, _, _, _, _, let waveformData):
                let cell: LearnStrategyAudioPlayerView = tableView.dequeueCell(for: indexPath)
                cell.delegate = self
                viewModel.audioPlayerViewDelegate = cell
                soundPattern = Property(waveformData)
                audioPlayerTopView = cell
                observeAudioPlayerView(cell)

                return cell
            default: fatalError("That should not happen!")
            }
        } else if
            viewModel.sectionCount(tabType: tabType) == 3 && indexPath.section == 2 ||
            viewModel.sectionCount(tabType: tabType) == 2 && viewModel.containsAudioItem(tabType: tabType) == false && indexPath.section == 1 {

                return relatedContentCell(tableView, indexPath)
        } else {
            switch item.contentItemValue {
            case .listItem(let itemText):
                return contentItemBulletTableViewCell(tableView: tableView, indexPath: indexPath, bulletText: itemText)
            case .text(let itemText, let style):
                var attributedTopText = item.contentItemValue.style(textStyle: style, text: itemText, textColor: .black)
                if style == .paragraph {
                    attributedTopText = Style.article(itemText, .black).attributedString(lineHeight: 2)
                }
                
                return contentItemTextTableViewCell(tableView: tableView,
                                                    indexPath: indexPath,
                                                    topText: attributedTopText,
                                                    bottomText: nil)
            case .audio(let title, _, _, _, let duration, _):
                return contentItemAudioCell(tableView: tableView,
                                            indexPath: indexPath,
                                            title: title,
                                            duration: duration)
            case .video(let title, _, let placeholderURL, _, let duration):
                let mediaDescription = String(format: "%@ (%02i:%02i)", title, Int(duration) / 60 % 60, Int(duration) % 60)
                return mediaStreamCell(tableView: tableView,
                                       indexPath: indexPath,
                                       title: title,
                                       placeholderURL: placeholderURL,
                                       attributedString: item.contentItemValue.style(textStyle: .paragraph,
                                                                                     text: mediaDescription,
                                                                                     textColor: .black40).attributedString(),
                                                                                     canStream: true)
            case .image(let title, _, let url):
                return imageTableViewCell(tableView: tableView,
                                          indexPath: indexPath,
                                          attributeString: item.contentItemValue.style(textStyle: .paragraph,
                                                                                       text: title,
                                                                                       textColor: .blackTwo).attributedString(),
                                                                                       url: url)
            case .pdf(let title, _, _):
                return PDFTableViewCell(tableView: tableView,
                                        indexPath: indexPath,
                                        attributedString: item.contentItemValue.style(textStyle: .h4, text: title, textColor: .blackTwo).attributedString(),
                                        timeToReadSeconds: item.secondsRequired)
            default:
                return invalidContentCell(tableView: tableView, indexPath: indexPath, item: item)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        guard indexPath.section != 0 else {
            return
        }

        switch viewModel.contentItemValue(at: indexPath, tabType: tabType) {
        case .audio:
            prepareAndPlay(at: indexPath)
        case .video(_, _, _, let videoURL, _):
            streamVideo(videoURL: videoURL)
        case .pdf(_, _, let pdfURL):
            delegate?.didTapPDF(withURL: pdfURL, in: self)
        default:
            if
                viewModel.sectionCount(tabType: tabType) == 3 && indexPath.section == 2 ||
                viewModel.sectionCount(tabType: tabType) == 2 && viewModel.containsAudioItem(tabType: tabType) == false && indexPath.section == 1 {
                    let selectedItem = viewModel.relatedContent(at: indexPath)
                    delegate?.didSelectReadMoreContentCollection(with: selectedItem.forcedRemoteID, in: self)
            }
        }
    }
}

// MARK: - Audio/Private

private extension LearnContentItemViewController {

    func prepareAndPlay(at indexPath: IndexPath) {
        let item = viewModel.learnContentItem(at: indexPath, tabType: tabType)

        switch item.contentItemValue {
        case .audio(_, _, _, let audioURL, let duration, let waveformData):
            let cell = itemTableView.cellForRow(at: indexPath) as? LearnStrategyPlaylistAudioCell
            viewModel.playItem(at: indexPath, audioURL: audioURL, duration: duration, cell: cell)

            if let audioPlayerTopView = audioPlayerTopView {
                soundPattern = Property(waveformData)
                observeAudioPlayerView(audioPlayerTopView)
            }
        default: return
        }
    }

    func observeAudioPlayerView(_ audioView: LearnStrategyAudioPlayerView) {
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
    }

    func observeViewModelPlayerUpdates() {
        viewModel.updates.observeNext { [unowned self] (update: CollectionUpdate) in
            switch update {
            case .update(_, let insertions, _):
                if let endedIndexPath = insertions.first {
                    let numberOfRows = self.itemTableView.numberOfRows(inSection: endedIndexPath.section)
                    if endedIndexPath.row + 1 < numberOfRows {
                        let nextIndexPath = IndexPath(row: endedIndexPath.row + 1, section: endedIndexPath.section)
                        self.prepareAndPlay(at: nextIndexPath)
                    } else {
                        let cell = self.itemTableView.cellForRow(at: endedIndexPath) as? LearnStrategyPlaylistAudioCell
                        cell?.resetPlayIcon()
                    }
                }
            case .reload: return
            }
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
        view.addSubview(itemTableView)
        view.backgroundColor = .clear
        itemTableView.topAnchor == view.topAnchor
        itemTableView.bottomAnchor == view.bottomAnchor
        itemTableView.horizontalAnchors == view.horizontalAnchors
        itemTableView.backgroundColor = .clear
    }

    func shouldMarkItemAsViewed(contentItem: ContentItem?) {
        guard let contentItem = contentItem, contentItem.viewed == false else {
            return
        }

        viewModel.didViewContentItem(localID: contentItem.localID)
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
            string: String(format: "%d MIN TO READ", relatedContent.minutesToRead), //TODO Localise
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

    func readMoreTableViewCell(tableView: UITableView, indexPath: IndexPath) -> LearnReadMoreCell {
        let readMoreCell: LearnReadMoreCell = tableView.dequeueCell(for: indexPath)
        readMoreCell.configure(numberOfArticles: viewModel.pdfCount(at: indexPath, tabType: tabType))

        return readMoreCell
    }

    func contentItemAudioCell(tableView: UITableView,
                              indexPath: IndexPath,
                              title: String,
                              duration: TimeInterval) -> LearnStrategyPlaylistAudioCell {
        let cell: LearnStrategyPlaylistAudioCell = tableView.dequeueCell(for: indexPath)
        cell.setup(title: title, playing: viewModel.isPlaying(indexPath: indexPath))

        return cell
    }

    func contentItemBulletTableViewCell(tableView: UITableView,
                                        indexPath: IndexPath,
                                        bulletText: String) -> LearnContentItemBulletCell {
        let bulletCell: LearnContentItemBulletCell = tableView.dequeueCell(for: indexPath)
        bulletCell.setupView(bulletText: bulletText)

        return bulletCell
    }

    func contentItemTextTableViewCell(tableView: UITableView,
                                      indexPath: IndexPath,
                                      topText: NSAttributedString,
                                      bottomText: NSAttributedString?) -> ContentItemTextTableViewCell {
        let itemTextCell: ContentItemTextTableViewCell = tableView.dequeueCell(for: indexPath)
        itemTextCell.setup(topText: topText, bottomText: bottomText)

        return itemTextCell
    }

    func mediaStreamCell(tableView: UITableView,
                         indexPath: IndexPath,
                         title: String,
                         placeholderURL: URL,
                         attributedString: NSAttributedString,
                         canStream: Bool) -> ImageSubtitleTableViewCell {
        let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        imageCell.mainImageView.backgroundColor = .black
        imageCell.mainImageView.layer.borderColor = UIColor.black.cgColor
        imageCell.mainImageView.layer.borderWidth = 0.5
        imageCell.setupData(placeHolder: placeholderURL,
                            description: attributedString,
                            canStream: canStream)
        imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))

        return imageCell
    }

    func imageTableViewCell(tableView: UITableView,
                            indexPath: IndexPath,
                            attributeString: NSAttributedString,
                            url: URL) -> ImageSubtitleTableViewCell {
        let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        imageCell.setupData(placeHolder: url, description: attributeString, canStream: false)
        imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))

        return imageCell
    }

    func invalidContentCell(tableView: UITableView, indexPath: IndexPath, item: ContentItem) -> ErrorCell {
        let cell: ErrorCell = tableView.dequeueCell(for: indexPath)
        cell.configure(text: R.string.localized.commonInvalidContent(), item: item)

        return cell
    }

    func PDFTableViewCell(tableView: UITableView, indexPath: IndexPath, attributedString: NSAttributedString, timeToReadSeconds: Int) -> LearnPDFCell {
        let cell: LearnPDFCell = tableView.dequeueCell(for: indexPath)
        cell.configure(titleText: attributedString, timeToReadSeconds: timeToReadSeconds)

        return cell
    }
}

// MARK: - TabBarViewDelegate

extension LearnContentItemViewController: TabBarViewDelegate {

    func didSelectItemAtIndex(index: Int, sender: TabBarView) {
        itemTableView.reloadData()
    }
}

// MARK: - AudioPlayerViewSliderDelegate

extension LearnContentItemViewController: AudioPlayerViewSliderDelegate {

    func value(at layout: Float, in view: LearnStrategyAudioPlayerView) {
        viewModel.forward(value: layout)
    }
}

// MARK: - UIScrollViewDelegate

extension LearnContentItemViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let parent = parent as? PageScroll {
            parent.pageDidScroll(self, scrollView: itemTableView)
        }
    }
}

// MARK: - Page

extension LearnContentItemViewController: PageScrollView {

    func scrollView() -> UIScrollView {
        return itemTableView
    }
}
