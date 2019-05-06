//
//  ArticleViewController.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import AMScrollingNavbar

protocol ArticleDelegate: class {
    func didTabMarkAsRead()
}

var colorMode = ColorMode.dark

enum ColorMode {
    case dark
    case darkNot

    var backgroundColor: UIColor {
        switch self {
        case .dark: return .carbonDark
        case .darkNot: return .sand
        }
    }

    var tintColor: UIColor {
        switch self {
        case .dark: return .accent
        case .darkNot: return .accent
        }
    }

    var textColor: UIColor {
        switch self {
        case .dark: return .sand
        case .darkNot: return .carbonDark
        }
    }

    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .dark: return .lightContent
        case .darkNot: return .default
        }
    }
}

final class ArticleNavigationController: ScrollingNavigationController {}

final class ArticleViewController: UIViewController {

    // MARK: - Properties
    var interactor: ArticleInteractorInterface?
    weak var delegate: ArticleItemViewControllerDelegate?
    private var header: Article.Header?
    private var audioPlayerBar = AudioPlayerBar()
    private var audioPlayerFullScreen = AudioPlayerFullScreen()
    private var audioButton = AudioButton()
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var topTitleNavigationItem: UINavigationItem!
    @IBOutlet private weak var bottombar: UIToolbar!
    @IBOutlet private weak var moreBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var closeButtonItem: UIBarButtonItem!

    private lazy var bookMarkBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_bookmark(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTabBookmarkItem))
        item.width = view.frame.width * 0.25 //TODO calculations depends on the number of new items, do we show share etc...
        item.tintColor = colorMode.tintColor
        return item
    }()

    private lazy var nightModeBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_night_mode_unselected(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTabDarkModeItem))
        item.width = view.frame.width * 0.25
        item.tintColor = colorMode.tintColor
        return item
    }()

    private lazy var textScaleBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_text_scale(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTabTextScaleItem))
        item.width = view.frame.width * 0.25
        item.tintColor = colorMode.tintColor
        return item
    }()

    private lazy var shareBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_share_sand(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTabShareItem))
        item.width = view.frame.width * 0.25
        item.tintColor = colorMode.tintColor
        return item
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50,
                                                  followers: [NavigationBarFollower(view: bottombar,
                                                                                    direction: .scrollDown)])
        }
        setColorMode()
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = ColorMode.darkNot.backgroundColor
    }
}

// MARK: - Private

private extension ArticleViewController {
    func setupTableView() {
        tableView.registerDequeueable(ContentItemTextTableViewCell.self)
        tableView.registerDequeueable(ImageSubtitleTableViewCell.self)
        tableView.registerDequeueable(ArticleRelatedCell.self)
        tableView.registerDequeueable(LearnPDFCell.self)
        tableView.registerDequeueable(ErrorCell.self)
        tableView.registerDequeueable(ArticleTextHeaderTableViewCell.self)
        tableView.registerDequeueable(ArticleImageHeaderTableViewCell.self)
        tableView.registerDequeueable(ArticleRelatedWhatsHotTableViewCell.self)
        tableView.registerDequeueable(ArticleBulletPointTableViewCell.self)
        tableView.registerDequeueable(MarkAsReadTableViewCell.self)
        tableView.registerDequeueable(ArticleRelatedTableViewCell.self)
        tableView.registerDequeueable(FoundationTableViewCell.self)
        tableView.tableFooterView = UIView()
    }

    func setupAudioPlayerView() {
        audioPlayerBar = AudioPlayerBar.instantiateFromNib()
        bottombar.addSubview(audioPlayerBar)
        audioPlayerBar.isHidden = true
        audioPlayerBar.viewDelegate = self
    }

    func setupAudioItem() {
        guard let audioItem = interactor?.audioItem else { return }
        audioButton = AudioButton.instantiateFromNib()
        audioButton.configure(categoryTitle: interactor?.categoryTitle ?? "",
                              title: interactor?.title ?? "",
                              audioURL: interactor?.audioURL,
                              remoteID: interactor?.remoteID ?? 0,
                              duration: audioItem.type.duration,
                              viewDelegate: self)
        bottombar.addSubview(audioButton)
        audioButton.trailingAnchor == bottombar.trailingAnchor - 24
    }

    func showHideCloseButton() {
        closeButtonItem.isEnabled = !closeButtonItem.isEnabled
        closeButtonItem.tintColor = closeButtonItem.isEnabled == true ? colorMode.tintColor : .clear
    }

    func setColorMode() {
        UIApplication.shared.setStatusBarStyle(colorMode.statusBarStyle)
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.apercuMedium(ofSize: 20),
                                                            .foregroundColor: colorMode.textColor]
        UIApplication.shared.statusBarView?.backgroundColor = colorMode.backgroundColor
        navigationController?.navigationBar.barTintColor = colorMode.backgroundColor
        view.backgroundColor = colorMode.backgroundColor
        bottombar.barTintColor = colorMode.backgroundColor
    }
}

// MARK: - Actions

private extension ArticleViewController {
    @IBAction func didTabDismiss() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didTabMoreButton() {
        if topTitleNavigationItem.leftBarButtonItems == nil ||
            topTitleNavigationItem.leftBarButtonItems?.isEmpty == true {
            topTitleNavigationItem.title = nil
            topTitleNavigationItem.setLeftBarButtonItems([bookMarkBarButtonItem,
                                                          nightModeBarButtonItem,
                                                          textScaleBarButtonItem,
                                                          shareBarButtonItem], animated: true)
        } else {
            topTitleNavigationItem.setLeftBarButtonItems([], animated: true)
            if topTitleNavigationItem.title == nil {
                if (tableView.visibleCells.filter { $0.tag == 111 }).isEmpty == true {
                    topTitleNavigationItem.title = header?.title
                }
            }
        }
    }

    @objc func didTabBookmarkItem() {
        dismiss(animated: true, completion: nil)
    }

    @objc func didTabDarkModeItem() {
        colorMode = colorMode == .dark ? .darkNot : .dark
        setColorMode()
        tableView.reloadData()
    }

    @objc func didTabTextScaleItem() {
        dismiss(animated: true, completion: nil)
    }

    @objc func didTabShareItem() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ArticleViewControllerInterface

extension ArticleViewController: ArticleViewControllerInterface {
    func setupArticleHeader(header: Article.Header) {
        self.header = header
    }

    func setupView() {
        setupTableView()
        setupAudioPlayerView()
        setupAudioItem()
        setColorMode()
        bottombar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }
}

// MARK: - Cells

extension ArticleViewController {
    func articleItemTextViewCell(tableView: UITableView,
                                 indexPath: IndexPath,
                                 topText: NSAttributedString,
                                 bottomText: NSAttributedString?) -> ContentItemTextTableViewCell {
        let itemTextCell: ContentItemTextTableViewCell = tableView.dequeueCell(for: indexPath)
        itemTextCell.setup(topText: topText, bottomText: bottomText, delegate: self)
        itemTextCell.backgroundColor = .clear
        itemTextCell.contentView.backgroundColor = .clear
        return itemTextCell
    }

    func mediaStreamCell(tableView: UITableView,
                         indexPath: IndexPath,
                         title: String,
                         imageURL: URL?,
                         placeholderImage: UIImage? = R.image.preloading(),
                         attributedString: NSAttributedString,
                         canStream: Bool) -> ImageSubtitleTableViewCell {
        let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        imageCell.setupData(imageURL: imageURL,
                            placeholderImage: placeholderImage,
                            description: attributedString,
                            canStream: canStream)
        imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))
        return imageCell
    }

    func imageTableViweCell(tableView: UITableView,
                            indexPath: IndexPath,
                            attributeString: NSAttributedString,
                            url: URL) -> ImageSubtitleTableViewCell {
        let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        imageCell.setupData(imageURL: url, description: attributeString, canStream: false)
        imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))
        imageCell.backgroundColor = .clear
        imageCell.contentView.backgroundColor = .clear
        return imageCell
    }

    func PDFTableViewCell(tableView: UITableView,
                          indexPath: IndexPath,
                          attributedString: NSAttributedString,
                          timeToReadSeconds: Int) -> LearnPDFCell {
        let cell: LearnPDFCell = tableView.dequeueCell(for: indexPath)
        cell.backgroundColor = .clear
        cell.configure(titleText: attributedString,
                       timeToReadSeconds: timeToReadSeconds,
                       titleColor: .white,
                       timeColor: .gray)
        return cell
    }

    func invalidContentCell(tableView: UITableView, indexPath: IndexPath, item: Article.Item) -> ErrorCell {
        let cell: ErrorCell = tableView.dequeueCell(for: indexPath)
        cell.configure(text: R.string.localized.commonInvalidContent(), item: item)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }

    func relatedArticleCell(tableView: UITableView, indexPath: IndexPath) -> ArticleRelatedWhatsHotTableViewCell {
        let relatedArticleCell: ArticleRelatedWhatsHotTableViewCell = tableView.dequeueCell(for: indexPath)
        let relatedArticle = interactor?.relatedArticle(at: indexPath)
        relatedArticleCell.configure(title: relatedArticle?.title,
                                     publishDate: relatedArticle?.publishDate,
                                     author: relatedArticle?.author,
                                     timeToRead: relatedArticle?.timeToRead,
                                     imageURL: relatedArticle?.imageURL,
                                     isNew: relatedArticle?.isNew ?? false)
        return relatedArticleCell
    }

    func emptyCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }

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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return interactor?.sectionCount ?? 0
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.itemCount(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = interactor?.articleItem(at: indexPath) else { return }
        switch item.type {
        case .headerText: topTitleNavigationItem.title = nil
        case .button:
            if let markAsReadCell = cell as? MarkAsReadTableViewCell {
                markAsReadCell.setMarkAsReadStatus(read: true)
            }
        default: return
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = interactor?.articleItem(at: indexPath) else { return }
        switch item.type {
        case .headerText:
            topTitleNavigationItem.setLeftBarButtonItems([], animated: true)
            topTitleNavigationItem.title = header?.title
        default: return
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.articleItem(at: indexPath) else {
            return emptyCell(tableView: tableView, indexPath: indexPath)
        }
        switch item.type {
        case .headerText(let header):
            let cell: ArticleTextHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(articleHeader: header)
            return cell
        case .headerImage(let imageURLString):
            let cell: ArticleImageHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(imageURLString: imageURLString)
            return cell
        case .audio(let title, _, let imageURL, _, _, _):
            return mediaStreamCell(
                tableView: tableView,
                indexPath: indexPath,
                title: title,
                imageURL: imageURL,
                placeholderImage: R.image.audioPlaceholder(),
                attributedString: Style.mediaDescription(title,
                                                         colorMode.textColor.withAlphaComponent(0.6)).attributedString(lineHeight: 2),
                canStream: true)
        case .image(let title, _, let url):
            return imageTableViweCell(
                tableView: tableView,
                indexPath: indexPath,
                attributeString: Style.mediaDescription(title,
                                                        colorMode.textColor.withAlphaComponent(0.6)).attributedString(lineHeight: 2),
                url: url)
        case .listItem(let bullet):
            let cell: ArticleBulletPointTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(bullet: bullet)
            return cell
//            return articleItemTextViewCell(tableView: tableView,
//                                           indexPath: indexPath,
//                                           topText: item.type.style(textStyle: .paragraph,
//                                                                    text: text,
//                                                                    textColor: .white),
//                                           bottomText: nil)
        case .text(let text, let style):
            var attributedTopText = item.type.style(textStyle: style,
                                                    text: text,
                                                    textColor: colorMode.textColor)
            if style.headline == true {
                attributedTopText = item.type.style(textStyle: style,
                                                    text: text.uppercased(),
                                                    textColor: colorMode.textColor)
            } else if style == .paragraph {
                attributedTopText = Style.article(text, colorMode.textColor).attributedString(lineHeight: 1.8)
            } else if style == .quote {
                attributedTopText = Style.qoute(text,
                                                colorMode.textColor.withAlphaComponent(0.6)).attributedString(lineHeight: 1.8)
            }
            return articleItemTextViewCell(tableView: tableView,
                                           indexPath: indexPath,
                                           topText: attributedTopText,
                                           bottomText: nil)
        case .video(let title, _, let placeholderURL, _, let duration):
            let mediaDescription = String(format: "%@ (%02i:%02i)", title, Int(duration) / 60 % 60, Int(duration) % 60)
            let cell: FoundationTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, timeToWatch: mediaDescription, imageURL: placeholderURL)
            return cell
        case .pdf(let title, let description, _, _):
            let cell: ArticleRelatedTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title,
                           durationString: description ?? "",
                           icon: R.image.ic_seen_of())
            return cell
        case .articleRelatedWhatsHot(let relatedArticle):
            let cell: ArticleRelatedWhatsHotTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: relatedArticle.title,
                           publishDate: relatedArticle.publishDate,
                           author: relatedArticle.author,
                           timeToRead: relatedArticle.timeToRead,
                           imageURL: relatedArticle.imageURL,
                           isNew: relatedArticle.isNew)
            return cell
        case .button(let selected):
            let cell: MarkAsReadTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(selected: selected)
            cell.delegate = self
            return cell
        default:
            return invalidContentCell(tableView: tableView, indexPath: indexPath, item: item)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = interactor?.articleItem(at: indexPath) else {
            return UITableViewAutomaticDimension
        }
        switch item.type {
        case .articleRelatedWhatsHot: return 215
        case .pdf: return 95
        default: return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = interactor?.articleItem(at: indexPath) else { return }
        switch item.type {
        case .audio(_, _, _, let remoteURL, _, _):
            let url = item.bundledAudioURL ?? remoteURL
            delegate?.didTapMedia(withURL: url, in: self)
        case .video(_, _, _, let videoURL, _):
            let playerViewController = stream(videoURL: videoURL, contentItem: nil, pageName: PageName.search)
            if let playerItem = playerViewController.player?.currentItem {
                let avPlayerObserver = AVPlayerObserver(playerItem: playerItem)
                avPlayerObserver.onStatusUpdate { (player) in
                    if playerItem.status == .failed {
                        playerViewController.presentNoInternetConnectionAlert(in: playerViewController)
                    }
                }
            }
        case .pdf(let title, _, let pdfURL, let itemID):
            didTapPDFLink(title, itemID, pdfURL)
        default: return
        }
    }
}

// MARK: - ClickableLabelDelegate

extension ArticleViewController: ClickableLabelDelegate {
    func openLink(withURL url: URL) {
        interactor?.didTapLink(url)
    }
}

// MARK: - ArticleDelegate

extension ArticleViewController: ArticleDelegate {
    func didTabMarkAsRead() {
        interactor?.markArticleAsRead()
    }
}

// MARK: - AudioPlayerViewDelegate

extension ArticleViewController: AudioPlayerViewDelegate {
    func didTabClose(for view: AudioPlayer.View) {
        switch view {
        case .bar:
            showHideCloseButton()
            audioPlayerBar.isHidden = true
            audioButton.isHidden = false
        case .fullScreen:
            audioPlayerBar.updateView()
            audioPlayerFullScreen.animateHidden(true)
            navigationController?.navigationBar.isHidden = false
        }
    }

    func didTabPlayPause(categoryTitle: String, title: String, audioURL: URL?, remoteID: Int) {
        if audioPlayerBar.isHidden == true {
            showHideCloseButton()
            audioPlayerBar.isHidden = false
        }
        audioButton.isHidden = !audioPlayerBar.isHidden
        audioPlayerBar.configure(categoryTitle: categoryTitle, title: title, audioURL: audioURL, remoteID: remoteID)
    }

    func didFinishAudio() {
        tableView.reloadData()
    }

    func openFullScreen() {
        audioPlayerFullScreen = AudioPlayerFullScreen.instantiateFromNib()
        audioPlayerFullScreen.viewDelegate = self
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
            self.navigationController?.navigationBar.isHidden = true
            self.audioPlayerFullScreen.isHidden = false
        }
    }
}
