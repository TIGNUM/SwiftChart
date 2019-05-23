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
var textScale = TextScale.scaleNot

enum ColorMode {
    case dark
    case darkNot

    var background: UIColor {
        switch self {
        case .dark: return .carbon
        case .darkNot: return .sand
        }
    }

    var audioBackground: UIColor {
        switch self {
        case .dark: return .sand
        case .darkNot: return .carbonDark
        }
    }

    var audioVissualEffect: UIBlurEffect.Style {
        switch self {
        case .dark: return .dark
        case .darkNot: return .light
        }
    }

    var audioText: UIColor {
        switch self {
        case .dark: return UIColor.carbon.withAlphaComponent(0.6)
        case .darkNot: return UIColor.sand.withAlphaComponent(0.6)
        }
    }

    var fade: UIColor {
        switch self {
        case .dark: return UIColor.carbon.withAlphaComponent(0.1)
        case .darkNot: return UIColor.sand.withAlphaComponent(0.1)
        }
    }

    var seperator: UIColor {
        switch self {
        case .dark: return UIColor.sand.withAlphaComponent(0.1)
        case .darkNot: return UIColor.carbon.withAlphaComponent(0.1)
        }
    }

    var tint: UIColor {
        switch self {
        case .dark: return .accent
        case .darkNot: return .accent
        }
    }

    var text: UIColor {
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

enum TextScale {
    case scale
    case scaleNot

    var categoryHeadline: UIFont {
        switch self {
        case .scale: return .sfProTextMedium(ofSize: 14)
        case .scaleNot: return .sfProTextMedium(ofSize: 12)
        }
    }

    var contentHeadline: UIFont {
        switch self {
        case .scale: return .sfProDisplayLight(ofSize: 40)
        case .scaleNot: return .sfProDisplayLight(ofSize: 34)
        }
    }

    var details: UIFont {
        switch self {
        case .scale: return .sfProTextMedium(ofSize: 14)
        case .scaleNot: return .sfProTextMedium(ofSize: 12)
        }
    }

    var bullet: UIFont {
        switch self {
        case .scale: return .sfProTextLight(ofSize: 24)
        case .scaleNot: return .sfProTextLight(ofSize: 16)
        }
    }

    var content: UIFont {
        switch self {
        case .scale: return .sfProTextRegular(ofSize: 24)
        case .scaleNot: return .sfProTextRegular(ofSize: 16)
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
    private var currentFadeView = GradientView(colors: [], locations: [])
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var topTitleNavigationItem: UINavigationItem!
    @IBOutlet private weak var moreBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var closeButton: UIButton!

    private lazy var customMoreButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(R.image.ic_more_unselected(), for: .normal)
        button.backgroundColor = UIColor.accent.withAlphaComponent(0.3)
        button.corner(radius: button.frame.width * 0.5)
        button.addTarget(self, action: #selector(didTabMoreButton), for: .touchUpInside)
        return button
    }()

    private lazy var bookMarkBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_bookmark(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTabBookmarkItem))
        item.width = view.frame.width * 0.25 //TODO calculations depends on the number of new items, do we show share etc...
        item.tintColor = colorMode.tint
        return item
    }()

    private lazy var nightModeBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_night_mode_unselected(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTabDarkModeItem))
        item.width = view.frame.width * 0.25
        item.tintColor = colorMode.tint
        return item
    }()

    private lazy var textScaleBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_text_scale(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTabTextScaleItem))
        item.width = view.frame.width * 0.25
        item.tintColor = colorMode.tint
        return item
    }()

    private lazy var shareBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_share_sand(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTabShareItem))
        item.width = view.frame.width * 0.25
        item.tintColor = colorMode.tint
        return item
    }()

    private lazy var topBarButtonItems: [UIBarButtonItem] = {
        if interactor?.isShareable == true {
            return [bookMarkBarButtonItem,
                    nightModeBarButtonItem,
                    textScaleBarButtonItem,
                    shareBarButtonItem]
        }
        return [bookMarkBarButtonItem,
                nightModeBarButtonItem,
                textScaleBarButtonItem]
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50)
        }
        setColorMode()
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBar(colorMode: ColorMode.darkNot)
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
        tableView.registerDequeueable(StrategyContentTableViewCell.self)
        tableView.tableFooterView = UIView()
    }

    func setupAudioPlayerView() {
        audioPlayerBar = AudioPlayerBar.instantiateFromNib()
        view.addSubview(audioPlayerBar)
        audioPlayerBar.trailingAnchor == view.trailingAnchor
        audioPlayerBar.leadingAnchor == view.leadingAnchor
        audioPlayerBar.bottomAnchor == view.bottomAnchor - 24
        audioPlayerBar.heightAnchor == 40
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
        view.addSubview(audioButton)
        audioButton.trailingAnchor == view.trailingAnchor - 24
        audioButton.bottomAnchor == view.bottomAnchor - 48
        audioButton.heightAnchor == 40
    }

    func updateCloseButton() {
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.accent.cgColor
        closeButton.corner(radius: closeButton.bounds.width * 0.5)
        view.bringSubview(toFront: closeButton)
    }

    func showHideCloseButton() {
        closeButton.isHidden = !closeButton.isHidden
    }

    func setColorMode() {
        UIApplication.shared.setStatusBarStyle(colorMode.statusBarStyle)
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.apercuMedium(ofSize: 20),
                                                            .foregroundColor: colorMode.text]
        UIApplication.shared.setStatusBar(colorMode: colorMode)
        navigationController?.navigationBar.barTintColor = colorMode.background
        view.backgroundColor = colorMode.background
        tableView.backgroundColor = colorMode.background
        currentFadeView.removeFromSuperview()
        currentFadeView = view.addFadeView(at: .bottom,
                                           height: 120,
                                           primaryColor: colorMode.background,
                                           fadeColor: colorMode.fade)
        audioButton.setColorMode()
        view.bringSubview(toFront: closeButton)
        view.bringSubview(toFront: audioButton)
        if audioPlayerBar.isHidden == false {
            audioPlayerBar.setColorMode()
            view.bringSubview(toFront: audioPlayerBar)
        }
    }

    func updateMoreButton(customView: UIView?) {
        moreBarButtonItem.customView = customView
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
            updateMoreButton(customView: customMoreButton)
            topTitleNavigationItem.title = nil
            topTitleNavigationItem.setLeftBarButtonItems(topBarButtonItems, animated: true)
        } else {
            updateMoreButton(customView: nil)
            topTitleNavigationItem.setLeftBarButtonItems([], animated: true)
            if topTitleNavigationItem.title == nil {
                if (tableView.visibleCells.filter { $0.tag == 111 }).isEmpty == true {
                    topTitleNavigationItem.title = header?.title
                }
            }
        }
    }

    @objc func didTabBookmarkItem() {
        showAlert(type: .comingSoon)
    }

    @objc func didTabDarkModeItem() {
        colorMode = colorMode == .dark ? .darkNot : .dark
        setColorMode()
        tableView.reloadData()
        didTabMoreButton()
    }

    @objc func didTabTextScaleItem() {
        textScale = textScale == .scaleNot ? .scale : .scaleNot
        tableView.reloadData()
        didTabMoreButton()
    }

    @objc func didTabShareItem() {
        showAlert(type: .comingSoon)
    }
}

// MARK: - ArticleViewControllerInterface

extension ArticleViewController: ArticleViewControllerInterface {
    func reloadData() {
        (navigationController as? ScrollingNavigationController)?.showNavbar(animated: true, duration: 0.3)
        tableView.reloadData()
        tableView.scrollToTop(animated: true)
    }

    func setupArticleHeader(header: Article.Header) {
        self.header = header
    }

    func setupView() {
        setupTableView()
        setupAudioPlayerView()
        setupAudioItem()
        setColorMode()
        updateCloseButton()
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
                                     isNew: relatedArticle?.isNew ?? false,
                                     colorMode: colorMode)
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
                                                         colorMode.text.withAlphaComponent(0.6)).attributedString(lineHeight: 2),
                canStream: true)
        case .image(let title, _, let url):
            return imageTableViweCell(
                tableView: tableView,
                indexPath: indexPath,
                attributeString: Style.mediaDescription(title,
                                                        colorMode.text.withAlphaComponent(0.6)).attributedString(lineHeight: 2),
                url: url)
        case .listItem(let bullet):
            let cell: ArticleBulletPointTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(bullet: bullet)
            return cell
        case .text(let text, let style):
            var attributedTopText = item.type.style(textStyle: style,
                                                    text: text,
                                                    textColor: colorMode.text)
            if style.headline == true {
                attributedTopText = item.type.style(textStyle: style,
                                                    text: text.uppercased(),
                                                    textColor: colorMode.text)
            } else if style == .paragraph {
                attributedTopText = Style.article(text, colorMode.text).attributedString(lineHeight: 1.8)
            } else if style == .quote {
                attributedTopText = Style.qoute(text,
                                                colorMode.text.withAlphaComponent(0.6)).attributedString(lineHeight: 1.8)
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
                           isNew: relatedArticle.isNew,
                           colorMode: colorMode)
            return cell
        case .button(let selected):
            let cell: MarkAsReadTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(selected: selected)
            cell.delegate = self
            return cell
        case .articleRelatedStrategy(let title, let description, _):
            let cell: ArticleRelatedTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title,
                           durationString: description,
                           icon: R.image.ic_seen_of())
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
        case .pdf,
             .articleRelatedStrategy: return 95
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
        case .articleRelatedWhatsHot(let relatedArticle):
            interactor?.showRelatedArticle(remoteID: relatedArticle.remoteID)
        case .articleRelatedStrategy(_, _, let remoteID):
            interactor?.showRelatedArticle(remoteID: remoteID)
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
            view.bringSubview(toFront: audioPlayerBar)
        }
        audioButton.isHidden = !audioPlayerBar.isHidden
        audioPlayerBar.configure(categoryTitle: categoryTitle,
                                 title: title,
                                 audioURL: audioURL,
                                 remoteID: remoteID)
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
        (navigationController as? ScrollingNavigationController)?.hideNavbar()
        UIView.animate(withDuration: 0.6) {
            self.audioPlayerFullScreen.isHidden = false
        }
    }
}
